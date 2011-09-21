open Lwt
open Cow
open Printf
open Slides

let rt = ">>" (* required to embed it in html p4 as cant put that token directly there *)
let dl = "$"

let backends num =
  { styles=[Fill];
    content= svg (sprintf "backends%d.svg" num)
  }
let modules num =
  { styles=[Fill];
    content= svg (sprintf "modules%d.svg" num)
  }

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
backends 1;
backends 2;
backends 3;
backends 4;
{ styles=[];
  content = <:html<
   <h3>Motivation</h3>
   <ul>
     <li><b>Portability</b>: minimise platform dependencies, leverage functional programming</li>
     <li><b>Security</b>: replace millions of lines of C with safer/smaller OCaml</li>
     <li><b>"Fat-free"</b>: compile out the layers for energy efficiency and performance</li>
   </ul>
  >>
};
modules 1;
modules 2;
modules 3;
modules 4;
{
  styles=[];
  content= <:html<
    <h3>Show Me The Code!</h3>
    <ul>
      <li><a href="http://github.com/avsm/mirage/tree/master/lib"><tt>lib/</tt></a> - core libraries</li>
      <ul>
        <li><a href="http://github.com/avsm/mirage/tree/master/lib/std"><tt>lib/std</tt></a> - Standard library</li>
        <li><a href="http://github.com/avsm/mirage/tree/master/lib/os"><tt>lib/os</tt></a> - OS alternatives</li>
        <ul>
          <li><a href="http://github.com/avsm/mirage/tree/master/lib/os/unix"><tt>lib/os/unix</tt></a> - UNIX platform</li>
          <li><a href="http://github.com/avsm/mirage/tree/master/lib/os/xen"><tt>lib/os/xen</tt></a> - Xen platform</li>
        </ul>
        <li><a href="http://github.com/avsm/mirage/tree/master/lib/net"><tt>lib/net</tt></a> - Net alternatives</li>
        <ul>
          <li><a href="http://github.com/avsm/mirage/tree/master/lib/net/direct"><tt>lib/net/direct</tt></a> - Ethernet to TCP/IP stack</li>
          <li><a href="http://github.com/avsm/mirage/tree/master/lib/net/socket"><tt>lib/net/socket</tt></a> - Socket stack</li>
        </ul>
        <li><a href="http://github.com/avsm/mirage/tree/master/lib/block"><tt>lib/block</tt></a> - Block alternatives</li>
      </ul>
      <li><a href="http://github.com/avsm/mirage/tree/master/lib/http"><tt>lib/http</tt></a> - HTTP client/server</li>
      <li><a href="http://github.com/avsm/mirage/tree/master/syntax"><tt>syntax/</tt></a> - camlp4 extensions</li>
    </ul>
  >>
};
{ styles=[];
  content= <:html<
    <h3>Basic Mirage Commands</h3>
    <p><tt>mir-build</tt> is a wrapper over <tt>ocamlbuild</tt>.<br />
     Output files are in <tt>_build/</tt> and source is never modified.</p>
    <ul>
      <li><b><tt>mir-build -clean</tt></b> will remove all built files</li>
      <li><b><tt>mir-build -j 5</tt></b> runs a parallel build.</li>
    </ul>
    <ul>
       <li><b><tt>mir-run -b <i>backend</i> <i>binary</i></tt></b> will execute it (or you can call it directly too).</li>
       <li>We will cover the advanced options later!</li>
    </ul>
    <p>All of this build-time synthesis is wrapped by the powerful <tt>ocamlbuild</tt>, which supports dynamic dependencies.</p>
  >>
};
{ styles=[];
  content= <:html<
    <h3>Try it Out</h3>
    <p>Mirage also has extra rules. Prepend the backend name to your target:</p>
    <section><pre class="noprettyprint">
$str:dl$ cd mirage-tutorial/examples/hello
$str:dl$ mir-build unix-direct/hello.bin
$str:dl$ mir-build unix-socket/hello.bin
$str:dl$ mir-build xen/hello.xen  # need Linux x86_64
$str:dl$ mir-build node/hello.js  # need js_of_ocaml

$str:dl$ mir-run -b unix-socket _build/unix-socket/hello.bin
$str:dl$ mir-run -b unix-direct _build/unix-direct/hello.bin
$str:dl$ mir-run -b node _build/node/hello.js
$str:dl$ mir-run -b xen _build/xen/hello.xen
</pre></section>
<p>Got a working system? Lets make sure we do before moving on.</p>
  >>
};

]
