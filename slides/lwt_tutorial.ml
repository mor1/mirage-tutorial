open Lwt
open Cow
open Printf
open Slides

let rt = ">>" (* required to embed it in html p4 as cant put that token directly there *)
let dl = "$"

let threads num =
  let fname = "unix_threads" ^ (string_of_int num) ^ ".svg" in
{
  styles=[Fill];
  content= <:html<
    <section>
    <object data=$str:fname$ type="image/svg+xml">&nbsp;</object>
    </section>
  >>
}

let slides = [
{ styles=[];
  content= <:html<
    <h1>Lightweight Threading
    <br />
     <small>using the Lwt library</small>
    </h1>
    <p>Raphael Proust, Balraj Singh and Anil Madhavapeddy</p>
  >>
};
{
  styles=[];
  content= <:html<
    <h3>Lightweight Threads</h3>
    <ul>
     <li>Mirage is <b>event-driven</b> with no preemption. Containers execute until
         they cannot make progress, and then sleep until woken up.</li>
     <li><tt>Lwt</tt> wraps event callbacks to maintain the illusion of straight-line code.</li>
    </ul>
    <p>Let's look at some examples.
    They are all in<br /> <a href="https://github.com/avsm/mirage-tutorial/tree/master/">mirage-tutorial/examples/01-lwt</a>, and you build them by:</p>
    <section><pre class="noprettyprint">
$str:dl$ mir-build unix-socket/sleep.bin
$str:dl$ ./_build/unix-socket/sleep.bin</pre></section> 
    <p>More tutorial content is available at:<br /><a href="http://www.openmirage.org/wiki/tutorial-lwt">http://openmirage.org/wiki/tutorial-lwt</a> <i>(this tutorial)</i><br /><a href="http://ocsigen.org/lwt/manual/">http://ocsigen.org/lwt/manual/</a> <i>(Lwt manual)</i></p>
>>
  
}; 
{ 
  styles=[];
  content= <:html<
    <h3>The Lwt monad</h3>
<section><pre>
val return : 'a -> 'a Lwt.t
</pre></section> 
  <p><tt><a href="http://ocsigen.org/lwt/api/Lwt#VALreturn">Lwt.return</a> v</tt> builds a thread that returns with value <tt>v</tt>.</p>
<section><pre>
val bind : 'a Lwt.t -> ('a -> 'b Lwt.t) -> 'b Lwt.t
</pre></section> 
<p><tt><a href="http://ocsigen.org/lwt/api/Lwt#VALbind">Lwt.bind</a> t f</tt> creates a thread which waits for <tt>t</tt> to terminate, then pass the result to <tt>f</tt>. If <tt>t</tt> is a sleeping thread, then <tt>bind t f</tt> will sleep too, until <t>t terminates</t>.</p>
<section><pre>
val join : unit Lwt.t list -> unit Lwt.t
</pre></section> 
<p><tt><a href="http://ocsigen.org/lwt/api/Lwt#VALjoin">Lwt.join</a></tt> takes a list of threads and waits for them all to terminate.</p>
  >>
};
{ 
  styles=[];
  content= <:html<
    <h3>A Simple Sleeping Example</h3>
<pre>
  Lwt.bind
    (OS.Time.sleep 1.0)
    (fun () ->
       Lwt.bind
         (OS.Time.sleep 2.0)
         (fun () ->
            OS.Console.log "Wake up sleepy!\n";
            Lwt.return ()
         )
    )</pre>
<p>More natural ML style, via syntax extension:</p>
<pre>
  lwt () = OS.Time.sleep 1.0 in
  lwt () = OS.Time.sleep 2.0 in
  OS.Console.log "Wake up sleep!\n";
  Lwt.return ()</pre>
  >>
};
{
  styles=[];
  content= <:html<
   <h3>Lwt syntax extension</h3>
<p><tt>01-lwt/sleep.ml</tt> (<tt>make sleep</tt>)</p>
<pre>
  lwt () = OS.Time.sleep 1.0 in
  lwt () = OS.Time.sleep 2.0 in
  OS.Console.log "Wake up sleep!\n";
  Lwt.return ()</pre>
<p>After syntax transform: (<tt>make sleep.pp</tt>)</p>
<pre>
  let __pa_lwt_0 = OS.Time.sleep 1.0 in
  Lwt.bind __pa_lwt_0 (fun () ->
    let __pa_lwt_0 = OS.Time.sleep 2.0 in
    Lwt.bind __pa_lwt_0 (fun () -> 
      (OS.Console.log "Wake up sleep.ml!\n";
       Lwt.return ()
      )
    )
  )</pre>
>>
};
{ 
  styles=[];
  content= <:html<
    <h3>Behind the Scenes</h3>
    <p>The scheduler is itself written in OCaml, but is operating system specific. To consider UNIX:</p>
    <ul>
      <li>Scheduler: <tt><a href="http://github.com/avsm/mirage/blob/master/lib/os/unix/main.ml">mirage/lib/os/unix/main.ml</a></tt></li>
      <li>OCaml: <tt><a href="http://github.com/avsm/mirage/blob/master/lib/os/runtime_unix/evtchn_stubs.c">mirage/lib/os/unix/evtchn_stubs.c</a></tt></li>
    </ul>
    <pre>
let t,u = Lwt.task () in // t sleeps forever
Lwt.wakeup u "foo";      // and u can wake it up  
t                        // value of t is "foo" </pre>
<p>The outside world wakes up sleeping threads via the <tt><a href="http://ocsigen.org/lwt/api/Lwt#VALwakeup">Lwt.wakeup</a></tt> mechanism:</p>
<ul>
<li>Timeouts are stored in an efficient <a href="https://github.com/avsm/mirage/blob/master/lib/os/unix/time.ml">priority queue</a></li>
<li>I/O is woken up by <tt>select</tt>, <tt>kqueue</tt> or <tt>epoll</tt></li>
</ul>
  >>
};
threads 1;
threads 2;
threads 3;
threads 4;
threads 5;
threads 6;
]
