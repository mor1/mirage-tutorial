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
  content = <:html<
   <h3>Motivation</h3>
   <ul>
     <li><b>Portability</b>: minimise platform dependencies, leverage functional programming</li>
     <li><b>Security</b>: replace millions of lines of C with safer/smaller OCaml</li>
     <li><b>"Fat-free"</b>: compile out the layers for energy efficiency and performance</li>
   </ul>
  >>
};
{ styles=[];
  content= <:html<
   <h3>Recap: Run This Tutorial</h3>
<p>The tutorial is itself written in Mirage, so build it by:</p>
<pre class="noprettyprint">
$str:dl$ git clone http://github.com/avsm/mirage-tutorial
$str:dl$ cd mirage-tutorial/slides
$str:dl$ make
</pre>
<p>You can run it in many different combinations. The default is UNIX sockets. <b>Is anyone here running Xen?</b></p>
<table>
<tr><th>Target</th><th>Backend</th><th>Storage</th><th>Network</th> </tr>
<tr><td>run-socket_crunch</td><td>UNIX</td><td>Builtin</td><td>Sockets</td></tr>
<tr><td>run-socket_fs</td><td>UNIX</td><td>UNIX filesystem</td><td>Sockets</td></tr>
<tr><td>run-direct_crunch</td><td>UNIX</td><td>Disk image+OCaml</td><td>Tuntap+OCaml</td></tr>
<tr><td>run-direct_fs</td><td>UNIX</td><td>Disk image+OCaml</td><td>Tuntap+OCaml</td></tr>
<tr><td>run-xen_crunch</td><td>Xen</td><td>Builtin</td><td>Xennet+OCaml</td></tr>
<tr><td>run-xen_fs</td><td>Xen</td><td>Xenblock+OCaml</td><td>Xennet+OCaml</td></tr>
</table>
  >>
};

]
