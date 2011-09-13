open Cow
open Printf
open Slides

let rt = ">>"

let p1 = {
  styles=[Title];
  content= <:html< Building a Functional OS <br />CUFP 2011, Tokyo, Japan >>;
}

let p2 = {
  styles=[Fill];
  content= <:html<
<h3>Code</h3>
<section><pre>
<![CDATA[
open Lwt 
open OS

let main () =
  let heads =
    Time.sleep 1.0 $str:rt$
    return (Console.log "Heads");
  in
  let tails =
    Time.sleep 2.0 $str:rt$
    return (Console.log "Tails");
  in
  lwt () = heads <&> tails in
  Console.log "Finished";
  return ()
]]>
</pre></section>
   >>
}
  
let articles = [ p1 ] @ Intro.slides @ [ p2 ] 

let presentation = {
  topic="Mirage CUFP 2011 Tutorial";
  layout=Regular;
  articles;
}

let body = Xml.to_string (Slides.slides presentation)
