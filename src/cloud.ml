open Lwt
open Cow
open Printf
open Slides

let rt = ">>" (* required to embed it in html p4 as cant put that token directly there *)
let dl = "$"
let slides = [
{ styles=[];
  content= <:html<
    <h1>To The Cloud!
    <br />
     <small>where we're going, we don't need displays</small>
    </h1>
    <p>Anil Madhavapeddy and David Scott</p>
  >>
};
{
  styles=[];
  content= <:html<
    <h3>How Kernels Boot on Amazon</h3>
    <ul>
    </ul>
  >>
};
]

