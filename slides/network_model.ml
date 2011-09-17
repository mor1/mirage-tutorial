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
    <h3>OS.Devices.netif</h3>
    <ul>
      <li>...but not finished yet.</li>
    </ul>
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
