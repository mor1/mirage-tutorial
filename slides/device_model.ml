open Lwt
open Cow
open Printf
open Slides

let lt = "<"
let gt = ">"
let dl = "$"
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
<h3>Device Tree</h3>
<p>Defined in <a href="http://github.com/avsm/mirage/tree/master/lib/os/unix/devices.ml"><tt>lib/os/unix/devices.ml</tt></a>:</p>
<pre>
type entry = {
  provider : provider;
  id : string;
  depends : entry list;
  node : device;
} and device =
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
    <h3>type OS.Devices.blkif</h3>
    <p>Similar to a Unix block device</p>
    <p>Abstract object for read/write, with UNIX direct and Xen implementations, same signature.</p>
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

