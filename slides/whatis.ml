open Lwt
open Cow
open Printf
open Slides

let rt = ">>" (* required to embed it in html p4 as cant put that token directly there *)
let dl = "$"

let slides = [
{ styles=[];
  content= <:html<
    <h1>What is Mirage?
    <br />
    <small>"Fat-Free Application Synthesis"</small>
    </h1>
    <p>Anil Madhavapeddy</p>
    
  >>
};
{
  styles=[];
  content= <:html<
    <h3>Mirage: an Application Synthesis Framework</h3>
    <p>Write code in OCaml, and the system generates specialised outputs for:</p>
    <ul>
      <li><b>UNIX</b> binaries that use kernel sockets (like existing languages)</li>
      <li>UNIX alternative that uses <tt>tuntap</tt> and <tt>mmap</tt> to implement networking and filesystems in OCaml.</li>
      <li><b>Xen</b> microkernels that run directly against the hypervisor (no Linux underneath).</li>
      <li><b>Javascript</b> executables that run under <tt>node.js</tt></li>
      <li>...and easy to add more (OCamlJava, OCamlPIC?)</li>
    </ul>
    <div class="red">avsm: split this up into multiple slides with diagrams</div>
  >>
};
{ styles=[];
  content = <:html<
   <h3>Motivation</h3>
   <ul>
     <li><b>Portability</b>: minimise platform dependencies, leverage functional programming</li>
     <li><b>Security</b>: replace millions of lines of C with safer/smaller OCaml</li>
     <li><b>"Fat-free"</b>: layers of legacy software, compile out the layers for energy efficiency and performance</li>
   </ul>
    <div class="red">avsm: split this up into multiple slides with diagrams (from HotCloud paper perhaps)</div>
  >>
};
{ styles=[];
  content= <:html<
   <h3>Hello Mirage World (i)</h3>
   <p>Lets write some code that simply sleeps for a second, and outputs a string to the console.</p><br />
     <p>In a new directory, create <tt>hello.ml</tt>:</p>
     <section><pre>
let main () =
  OS.Time.sleep 1.0 $str:rt$
  OS.Console.log_s "Hello Mirage World!" $str:rt$
  OS.Time.sleep 1.0
</pre></section>
     <p>Now, build a UNIX binary:</p>
<section><pre class="noprettyprint">
$str:dl$ mir-build unix-socket/hello.bin
$str:dl$ ./_build/unix-socket/hello.bin
Hello Mirage World!
</pre></section>
  >>
};
{ styles=[];
  content= <:html<
    <h3>Hello Mirage World (ii)</h3>
    <p><tt>mir-build</tt> is a wrapper over <tt>ocamlbuild</tt>.<br />
     Output files are in <tt>_build/</tt> and source is never modified.</p>
    <ul>
      <li><tt>mir-build -clean</tt> will remove all built files</li>
      <li><tt>mir-build -j 5</tt> runs a parallel build.</li>
    </ul>
    <p>Mirage also has extra rules. Prepend the backend name to your target:</p>
    <section><pre class="noprettyprint">
$str:dl$ mir-build xen/hello.xen
$str:dl$ mir-build node/hello.js
$str:dl$ mir-build unix-direct/hello.bin
$str:dl$ mir-build unix-socket/hello.bin
</pre></section>
     <p>This builds various binaries from the same <tt>hello.ml</tt> file. We will introduce other options as the tutorial proceeds.</p>
  >>
};

]
