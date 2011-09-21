open Lwt
open Slides

 (* required to embed it in html p4 as cant put that token directly there *)
let html = "<:html<"
let html = <:html<$str:html$>>

let css = "<:css<"
let css = <:html<$str:css$>>

let cl = ">>"
let cl = <:html<$str:cl$>>

let dl = "$"
let dl = <:html<$str:dl$>>

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
     <li>Very convenient way to perform code-generation.</li>
     <li>OCaml has a comprehensive grammar extension mechanism.</li>
     <li>But integrating and composing syntax extensions can be difficult.</li>
    </ul>
    <p>Mirage features a bundle that is always available, so you never need to worry about them working together or being available.</p>
  >>
};
{
  styles  =[];
  content = <:html<
    <h3>Web Syntax Extension</h3>
    <ul>
      <li>Web expressions are written natively in Mirage (where they are called quotations):
      <pre>let x = $html$&#60;h1>Hello&#60;/h1>World!$cl$</pre></li>

       <li>This expands to (<tt>make %.pp.ml</tt>):
       <pre>
let x = List.flatten [
  [ `El ((("", "h1"), []), [ `Data "Hello" ]) ];
  [ `Data "World!" ]
]</pre></li>
      
      <li>HTML and XML quotations are compiled to <tt>xmlm</tt> expressions by the pre-processor.</li>
    </ul> >>
};
{
  styles = [];
  content = <:html<
    <h3>Web Syntax extensions</h3>
    <ul>
      <li>One can use template-like (anti-quotations) to parameterize quotations:
      <pre>let x title = $html$&#60;h1>$dl$title$dl$&#60;/h1>content$cl$</pre></li>

      <li>This expands to:
      <pre>
let x title = List.flatten
  [ [ `El ((("", "h1"), []), title) ];
    [ `Data "content" ] ]</pre></li>
      
      <li>Typed templates:
      <pre>
let f (i : int) = $html$This is an int : $dl$int:i$dl$!$cl$
let f (s : string) = $html$This is a string : $dl$string:s$dl$!$cl$</pre></li>
   </ul>
  >>
};
{
  styles  = [];
  content = <:html<
    <h3>Web Syntax extensions</h3>
    <ul>
    <li>CSS quotations (with nested declarations):
    <pre>let y = $css$ h1 {background-color: blue; a { color: red; } } } $cl$</pre></li>

    <li>This expands to:
<pre>
let y = Cow.Css.unroll (
  Cow.Css.Props [
    Cow.Css.Decl (
      [[ Cow.Css.Str "h1" ]],
      ([ Cow.Css.Prop ("background-color", [[ Cow.Css.Str "blue" ]]) ] @
       [ Cow.Css.Decl (
         [[ Cow.Css.Str "a" ]],
         [ Cow.Css.Prop ("color", [ [ Cow.Css.Str "red" ]]) ]) ]))
  ])</pre></li></ul>
>>
};
(*
{
  styles  = [];
  content = <:html<
    <h3>Web Syntax extensions</h3>
    <ul>
    <li></li>
    <ul>
   >>
}*)
]

