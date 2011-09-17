open Lwt
open Cow
open Printf
open Slides

let rt = ">>" (* required to embed it in html p4 as cant put that token directly there *)
let dl = "$"
let slides = [
{ styles=[];
  content= <:html<
    <h1>Lwt Exercises
    <br />
     <small>cool cooperative concurrency</small>
    </h1>
    <p>Raphael Proust, Balraj Singh and Anil Madhavapeddy</p>
  >>
};
{ 
  styles=[];
  content= <:html<
    <h3>LWT Examples Go Here</h3>
  >>
}
]

