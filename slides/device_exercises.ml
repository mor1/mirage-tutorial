open Lwt
open Cow
open Printf
open Slides

let rt = ">>" (* required to embed it in html p4 as cant put that token directly there *)
let dl = "$"
let slides = [
{ styles=[];
  content= <:html<
    <h1>Device Model Exercises
    <br />
     <small>taptaptap, is this thing on?</small>
    </h1>
    <p>Anil Madhavapeddy and David Scott</p>
  >>
};
{ styles=[];
  content= <:html<
   <h3>Start with kv_ro.ml</h3>
  >>
};
{
  styles=[];
  content= <:html<
    <h3>Crunch Filesystem</h3>
  >>
};
{
  styles=[];
  content= <:html<
    <h3>Unix pass through</h3>
  >>
};
{
  styles=[];
  content= <:html<
    <h3>Unix via VBD</h3>
  >>
};
]
