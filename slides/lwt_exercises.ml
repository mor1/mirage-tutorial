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
    <h3>Heads or Tails?</h3>
    <p>Write a program that spins off two threads, each of which sleep for some amount of time,
    say 1 and 2 seconds and then one prints "Heads", the other "Tails".</p>
    <p>After both have finished, it prints "Finished" and exits.</p>
<pre class="noprettyprint">
$str:dl$ cd mirage-tutorial/examples/01-lwt
$str:dl$ vim mysleep.ml
$str:dl$ make mysleep
# answer is in sleep.ml
</pre>
<p>Useful functions to know:</p>
<ul>
<li><tt>OS.Console.log</tt> and <tt>OS.Console.log_s</tt> (the Lwt version) print a string to console.</li>
<li><tt>Lwt.choose</tt> is used to wait for multiple threads to finish.</li>
</ul>
  >>
};
{ 
  styles=[];
  content= <:html<
    <h3>Echo Server</h3>
    <p>Write an echo server, reading from a dummy input generator and, for each input it reads, writes it to the console. The server should stop listening after 10 inputs are received.</p>
<pre class="noprettyprint">
$str:dl$ cd mirage-tutorial/examples/01-lwt
$str:dl$ vim myecho1.ml
$str:dl$ make myecho1
# answer is in echo1.ml
</pre>
<p>You can use this function as a traffic generator:</p>
<pre>
let read_line () =
  OS.Time.sleep (OS.Random.float 1.5) $str:rt$
  return (String.make (OS.Random.int 20) 'a')</pre>
  >>
}
]
