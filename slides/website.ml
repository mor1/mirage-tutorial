open Lwt
open Cow
open Printf
open Slides

let rt = ">>" (* required to embed it in html p4 as cant put that token directly there *)
let dl = "$"
let slides = [
{ styles=[];
  content= <:html<
    <h1>Build Your Website
    <br />
     <small>a personal kernel</small>
    </h1>
    <p>Anil Madhavapeddy and David Scott</p>
  >>
};
{
  styles=[];
  content= <:html<
    <h3>Skeleton HTTP Server</h3>
    <p>Mirage has a rather hacked up HTTP implementation (but it does work!) in $github "lib/http" "Http"$.</p> 
    <p>Take a shot at filling in your own website.</p>
<pre class="noprettyprint">
$str:dl$ cd mirage-tutorial/net/http
$str:dl$ vi server.ml
$str:dl$ vi dispatch.ml
$str:dl$ make
</pre>
<table>
<tr><th>Target</th><th>Backend</th><th>Storage</th><th>Network</th> </tr>
<tr><td>run-socket_crunch</td><td>UNIX</td><td>Builtin</td><td>Sockets</td></tr>
<tr><td>run-socket_fs</td><td>UNIX</td><td>UNIX filesystem</td><td>Sockets</td></tr>
<tr><td>run-direct_crunch</td><td>UNIX</td><td>Builtin</td><td>Tuntap+OCaml</td></tr>
<tr><td>run-direct_fs</td><td>UNIX</td><td>Disk image+OCaml</td><td>Tuntap+OCaml</td></tr>
<tr><td>run-xen_crunch</td><td>Xen</td><td>Builtin</td><td>Xennet+OCaml</td></tr>
<tr><td>run-xen_fs</td><td>Xen</td><td>Xenblock+OCaml</td><td>Xennet+OCaml</td></tr>
</table>
  >>
};
]

