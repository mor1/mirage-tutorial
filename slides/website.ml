open Lwt
open Cow
open Printf
open Slides

let rt = ">>" (* required to embed it in html p4 as cant put that token directly there *)
let dl = "$"
let slides = [
{ styles=[];
  content= <:html<
    <h1>Build Your Website
    <br />
     <small>a personal kernel</small>
    </h1>
    <p>Anil Madhavapeddy and David Scott</p>
  >>
};
{
  styles=[];
  content= <:html<
    <h3>Provide a skeleton repository in mirage-tutorial that can be filled in</h3>
    <p>Login details for laptops they can use with EC2 on them</p>
  >>
};
]

