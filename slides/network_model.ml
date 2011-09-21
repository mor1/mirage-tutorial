open Lwt
open Cow
open Printf
open Slides

let rt = ">>" (* required to embed it in html p4 as cant put that token directly there *)
let dl = "$"
let slides = [
{ styles=[];
  content= <:html<
    <h1>Networking
    <br />
     <small>here comes the HTTP bit</small>
    </h1>
    <p>Anil Madhavapeddy, Thomas Gazagnaire and David Scott</p>
  >>
};
{
  styles=[];
  content= <:html<
    <h3>Networking</h3>
    <ul>
      <li>Very similar to the block devices, except much more sensitive to latency.</li>
      <li>Xen provides Ethernet frames to the $github "lib/os/xen/netif.mli" "OS.Netif"$ driver, just as <tt>blkif</tt> provides sector-level access</li>
      <li>There are two separate shared rings: one for transmit, other for receive, and hardware offload options:</li>
    </ul>
<pre>
type features = {
  sg: bool;
  gso_tcpv4: bool;
  rx_copy: bool;
  rx_flip: bool;
  smart_poll: bool;
}
</pre>
  >>
};
{
  styles=[];
  content= <:html<
    <h3>Xen Net Interface</h3>
    <p>Similar to block, with ethernet interface. Good time to introduce the OCaml network stack.</p>
  >>
};

{
  styles=[];
  content= <:html<
    <h3>Ethernet and TCP/IP</h3>
    <p>Native implementation that exposes a similar interface to sockets. Attempts to be zero-copy, uses bitstring.</p>
  >>
};
]
