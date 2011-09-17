open Lwt
open Cow
open Printf
open Slides

let rt = ">>" (* required to embed it in html p4 as cant put that token directly there *)
let dl = "$"
let slides = [
{ styles=[];
  content= <:html<
    <h1>Syntax Extensions
    <br />
     <small>the zen of camlp4</small>
    </h1>
    <p>Thomas Gazagnaire and Anil Madhavapeddy</p>
  >>
};
{
  styles=[];
  content= <:html<
    <h3>Why Syntax Extensions?</h3>
    <ul>
     <li>Very convenient way to perform code-generation</li>
     <li>OCaml has a comprehensive grammar extension mechanism</li>
     <li>But integrating and composing them can be difficult</li>
    </ul>
    <p>Mirage features a bundle that is always available, so you never need to worry about them working together or being available.</p>
  >>
};
{ 
  styles=[];
  content= <:html<
    <h3>Syntax Examples Go Here</h3>
  >>
}
]

