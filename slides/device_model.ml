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
  >>
};
{
  styles=[];
  content= <:html<
    <h3>Synthesising Devices</h3>
    <ul>
      <li>So far, we can sleep and output to the console.</li>
      <li>Need a generic way to plug in I/O devices.</li>
      <li>But would like to do so both <i>statically</i> at compile-time, and <i>dynamically</i> from the environment</li>
      <li>A case where <b>OCaml Objects</b> are very useful!</li>
    </ul>
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
{
  styles=[];
  content= <:html<
    <h3>Providers</h3>
    <ul>
      <li>These are device managers that plugging and unplugging devices from the environment.</li>
      <li>Each provider registers at application startup, and communicates with the device manager
       (<a href="http://github.com/avsm/mirage/tree/master/lib/os/unix/devices.ml"><tt>lib/os/unix/devices.ml</tt></a>)
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
    <h3>Block Devices</h3>
    <p>Abstract object type for reading and writing sectors</p>
    <section><pre>
type blkif = &lt;
  id: string;
  read_page: int64 -> Bitstring.t Lwt.t;
  sector_size: int;
  ppname: string;
  destroy: unit;
&gt;
    </pre></section>
>>
};
{
  styles=[];
  content= <:html<
    <h3>Xen Block Interface: overview</h3>
    <ul>
    <li>Xen devices have <b>servers</b> (&quot;backends&quot;) and <b>clients</b> (&quot;frontends&quot;)</li>
    <li>Xen devices connect via a shared <b>directory service</b> (&quot;xenstore&quot;)</li>
    <li>Xen devices use <b>shared memory</b> and <b>interrupts</b> (&quot;event channels&quot;) for communication</li>
    </ul>
  >>
};
{
  styles=[];
  content= <:html<
    <h3>Xen Block Interface: connection</h3>
    <ol>
    <li>Control software writes &quot;backend&quot; and &quot;frontend&quot; information into xenstore.</li>
    <li>The backend and frontend both see the information, and learn about each other.</li>
    <li>Now that they have been introduced, they set up shared memory and event channels for future signalling.</li>
    </ol>
  >>
};
{
  styles=[];
  content= <:html<
    <h3>Xen Block Interface: data transfer</h3>
    <ol>
    <li>Payloads are written to 4KiB-aligned pages;</li>
    <li>Access is granted to the other domain via the hypervisor;</li>
    <li>Requests and responses are placed in a shared memory page (treated as a circular buffer or &quot;ring&quot;);</li>
    <li>Event channels (virtual interrupts) trigger processing.</li>
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
]

