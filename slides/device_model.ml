open Lwt
open Cow
open Printf
open Slides

let lt = "<"
let gt = ">"
let dl = "$"

let rings num =
{ styles=[];
  content=svg (sprintf "rings%d.svg" num)
}
    
let slides = [
{ styles=[];
  content= <:html<
    <h1>Devices and Storage
    <br />
     <small>reaching the outside world</small>
    </h1>
    <p>Anil Madhavapeddy and David Scott</p>
  >>
};
{
  styles=[];
  content= <:html<
    <h3>Bitstrings</h3>
    <p>New concept is <tt>Bitstring.t</tt>, from the <a href="http://code.google.com/p/bitstring/">Bitstring</a> library by <a href="http://people.redhat.com/~rjones/">Richard Jones</a>. It lets us avoid copying strings.</p>
    <pre>type bitstring = string * int * int</pre>
<p>A <tt>bitstring</tt> is a tuple of the <tt>string</tt> and an offset (in bits) and length (in bits) into that string.</p>
<p>I/O is often expressed as a stream of <tt>bitstring</tt> and can be converted to an OCaml string via <a href="http://github.com/avsm/mirage/tree/master/lib/std/bitstring_stream.ml"><tt>Bitstring_stream</tt></a>:</p>
<pre>type bitstream = Bitstring.t Lwt_stream.t
module Bitstring_stream : sig
val string_of_stream : bitstream -> string Lwt.t</pre>
>>
};
{ styles=[];
  content= <:html<
    <h3>Bitstring Patterns</h3>
<p>Used in most protocols. Below is <a href="http://github.com/avsm/mirage/tree/master/lib/fs/fat.ml">FAT filesystem</a>:</p>
<pre>bitmatch bits with
  | { _: 24: string;
      oem_name: (8 * 8): string;
      bytes_per_sector: (2 * 8): littleendian;
      sectors_per_cluster: (1 * 8): littleendian;
      reserved_sectors: (2 * 8): littleendian;
      number_of_fats: (1 * 8): littleendian;
      number_of_root_dir_entries: (2 * 8): littleendian;
      total_sectors_small: (2 * 8): littleendian;
      media_descriptor: (1 * 8): littleendian;
      sectors_per_fat: (2 * 8): littleendian;
      sectors_per_track: (2 * 8): littleendian;
      heads: (2 * 8): littleendian;
      hidden_preceeding_sectors: (4 * 8): littleendian;
      total_sectors_large: (4 * 8): littleendian;
      0xaa55: 16: littleendian, offset(0x1fe * 8)
    } -> ...</pre>
  >>
};
{
  styles=[];
  content= <:html<
    <h3>Getting Input</h3>
    <p>I/O is platform-specific, and exposed via $github "lib/os/xen/blkif.mli" "OS.Blkif"$ and $github "lib/os/unix/netif.mli" "OS.Netif"$.
 Each platform has a different low-level implementation behind the same signatures:</p>
    <ul>
      <li>UNIX uses sockets (via $github "lib/os/unix/socket.mli" "OS.Socket"$)</li>
      <li>Xen uses shared memory ring buffers (via $github "lib/os/xen/ring.mli" "OS.Ring"$)</li>
    </ul>
  >>
};
rings 1;
rings 2;
rings 3;
rings 4;
rings 5;
{ styles=[];
  content= <:html<
    <h3>Xen Shared Rings</h3>
    <p>The interface for $github "lib/os/xen/ring.mli" "OS.Ring"$ is quite generic.</p>
<pre>
type sring

module Front : sig
  // 'a is the response type, and 'b is the request id 
  type ('a,'b) t

  val init : sring:sring -> ('a,'b) t
  val slot : ('a,'b) t -> int -> Bitstring.t
  val nr_ents : ('a,'b) t -> int
  val get_free_requests : ('a,'b) t -> int
  val next_req_id: ('a,'b) t -> int
  val ack_responses : ('a,'b) t -> (Bitstring.t -> unit) -> unit
  val push_requests : ('a,'b) t -> unit
  val push_requests_and_check_notify : ('a,'b) t -> bool
end
</pre>
  <p>The source code has more comments!</p>
  >>
};
{ styles=[];
  content= <:html<
    <h3>Typed Rings for Block Transfer</h3>
    <p>The $github "lib/os/xen/ring.ml" "OS.Ring"$ module is generic, but specific devices have a defined
    request/response protocol, such as $github "lib/os/xen/blkif.ml" "OS.Blkif"$ below.
    In Mirage, the protocol is implemented in OCaml.</p>
<pre>
module Req : sig
  type op = Read | Write | Write_barrier | Flush | Unknown of int
  type seg = { gref : int32; first_sector : int; last_sector : int; }
  type t = {
    op : op;
    handle : int;
    id : int64;
    sector : int64;
    segs : seg array;
  }
end
module Res : sig
  type rsp = OK | Error | Not_supported | Unknown of int
  type t = { op : Req.op; st : rsp; }
end</pre>
  >>
};
{
  styles=[];
  content= <:html<
    <h3>Building a Xen Block Device</h3>
    <ol>
    <li>Payloads written to aligned pages; $github "lib/os/xen/io_page.mli" "OS.Io_page"$</li>
    <li>Access granted to the other domain; $github "lib/os/xen/gnttab.mli" "OS.Gntab"$</li>
    <li>RPCs are placed in the shared ring; $github "lib/os/xen/ring.mli" "OS.Ring"$</li>
    <li>Event channels trigger processing; $github "lib/os/xen/activations.mli" "OS.Activations"$</li>
    </ol>
<section><pre>
lib/os/xen/blkif.ml:
Io_page.with_page (* allocate 4KiB page *)
  (fun () ->
    Gnttab.with_grant (* allow backend to read it *)
      (fun () ->
        Ring.Front.push_request...
        Evtchn.notify ...
        ...
</pre></section>
  >>
};
{
  styles=[];
  content= <:html<
    <h3>A Generic Blkif</h3>
    <p>Now that we can push block requests to the ring, we can wrap this in the $github "lib/os/xen/blkif.ml" "OS.Blkif"$ type, which is a generic block device used by many devices in the system:</p>
<pre>
type blkif = &lt;
  id: string;
  read_page: int64 -> Bitstring.t Lwt.t;
  write_page: int64 -> Bitstring.t -> unit Lwt.t;
  sector_size: int;
  ppname: string;
  destroy: unit;
&gt;</pre>
<p>So there you go, we have built up a Xen-compatible device, with much of it in OCaml!</p>
>>
};
{
  styles=[];
  content= svg "xenblk.svg";
};
{
  styles=[];
  content= <:html<
    <h3>Synthesising Devices</h3>
    <ul>
      <li>So far, we can sleep and output to the console and have low-level devices (via sockets or pages).</li>
      <li>We need a generic way to plug in I/O devices.</li>
      <li>Would like to do so both <i>statically</i> at compile-time, and <i>dynamically</i> from the environment</li>
      <li>A case where <b>OCaml Objects</b> are very useful!</li>
    </ul>
  >>
};

{
  styles=[];
  content= <:html<
    <h3>Providers</h3>
    <ul>
      <li>These are device managers that plugging and unplugging devices from the environment.</li>
      <li>Each provider registers at application startup, and communicates with the $github "os/unix/devices.ml" "device manager"$
       via <tt><a href="http://ocsigen.org/lwt/api/Lwt_mvar">Lwt_mvar</a></tt> mailboxes).</li>
      <li>There are two provider types for this tutorial:</li>
      <ul>
         <li><a href="http://github.com/avsm/mirage/tree/master/lib/os/unix/devices.mli"><tt>OS.Devices.blkif</tt></a> for r/w block devices</li>
         <li><a href="http://github.com/avsm/mirage/tree/master/lib/os/unix/devices.mli"><tt>OS.Devices.kv_ro</tt></a> for r/o key/value store</li>
      </ul>
    </ul>
  >>
};
{
  styles=[];
  content= <:html<
    <h3>Device Types</h3>
    <p>We define two for this tutorial: a block device to read and write sectors to a disk.</p>
<pre>
type blkif = &lt;
  id: string;
  read_page: int64 -> Bitstring.t Lwt.t;
  sector_size: int;
  ppname: string;
  destroy: unit;
&gt;</pre>
<p>And also a higher level read-only key-value store:</p>
<pre>
type kv_ro = &lt;
  iter_s: (string -> unit Lwt.t) -> unit Lwt.t;
  read: string -> Bitstring.t Lwt_stream.t option Lwt.t;
  size: string -> int64 option Lwt.t;
&gt;
</pre>
>>
};
{ styles=[];
  content= <:html<

<h3>Device Tree (1)</h3>
<p>Defined in <a href="http://github.com/avsm/mirage/tree/master/lib/os/unix/devices.ml"><tt>lib/os/unix/devices.ml</tt></a>:</p>
<pre>
type entry = {
  provider : provider;
  id : string;
  depends : entry list;
  node : device;
}
</pre>
>>
};
{ styles=[];
  content= <:html<
<h3>Device Tree (2)</h3>
<p>Defined in <a href="http://github.com/avsm/mirage/tree/master/lib/os/unix/devices.ml"><tt>lib/os/unix/devices.ml</tt></a>:</p>
<pre>
type entry = {
  provider : provider;
  id : string;
  depends : entry list;
  node : device;
}
and device =
  | Blkif of blkif
  | Kv_RO of kv_ro
</pre>
>>
};
{ styles=[];
  content= <:html<
<h3>Device Tree (3)</h3>
<p>Defined in <a href="http://github.com/avsm/mirage/tree/master/lib/os/unix/devices.ml"><tt>lib/os/unix/devices.ml</tt></a>:</p>
<pre>
type entry = {
  provider : provider;
  id : string;
  depends : entry list;
  node : device;
}
and device =
  | Blkif of blkif
  | Kv_RO of kv_ro
and provider =
$str:lt$ create : deps:entry list -> cfg:(string * string) list
    -> id -> entry Lwt.t;
  id : string;
  plug : plug Lwt_mvar.t;
  unplug : id Lwt_mvar.t $str:gt$</pre>
>>
};
]
