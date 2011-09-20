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
]
