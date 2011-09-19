open Lwt
open Cow
open Printf
open Slides

let rt = ">>" (* required to embed it in html p4 as cant put that token directly there *)
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
    <h3>Challenge</h3>
    <ul>
      <li>Current kernels provide rich interfaces for interacting with storage devices
        <ul>
        <li>low-level: Unix block devices (/dev/sda)</li>
        <li>high-level: Unix filesystems</li>
        </ul>
      </li>
      <li>We need similar interfaces in Mirage!</li>
    </ul>
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

