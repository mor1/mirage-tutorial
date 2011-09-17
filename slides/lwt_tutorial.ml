open Lwt
open Cow
open Printf
open Slides

let rt = ">>" (* required to embed it in html p4 as cant put that token directly there *)
let dl = "$"
let slides = [
{ styles=[];
  content= <:html<
    <h3>Lightweight Threads</h3>
    <ul>
     <li>Mirage is <b>event-driven</b> with no preemption</li>
     <li><tt>Lwt</tt> transforms event callbacks into straight-line code</li>
     <li>Maximises portability across platforms, but takes some getting used to</li>
    </ul>
    <p>Lets try some examples for 10 minutes!<br />
    All are in <tt>mirage-tutorial.git/examples/lwt</tt>, and you build them by:</p>
    <section><pre class="noprettyprint">
$str:dl$ mir-build unix-socket/sleep.bin
$str:dl$ ./_build/unix-socket/sleep.bin
    </pre></section>
  >>
};
{ 
  styles=[];
  content= <:html<
    <h3>LWT Examples Go Here</h3>
  >>
}
]

