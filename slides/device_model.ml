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
      <li>Current kernels provide many devices globally (e.g. the filesystem tree)</li>
      <li>...</li>
    </ul>
  >>
};
{
  styles=[];
  content= <:html<
    <h3>type OS.Devices.blkif</h3>
    <p>Abstract object for read/write, with UNIX direct and Xen implementations, same signature.</p>
  >>
};
{
  styles=[];
  content= <:html<
    <h3>Xen Block Interface</h3>
    <p>Explain rings and such here?</p>
  >>
};
]

