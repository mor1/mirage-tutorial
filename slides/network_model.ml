open Lwt
open Cow
open Printf
open Slides

let rt = ">>" (* required to embed it in html p4 as cant put that token directly there *)
let dl = "$"
let slides = [
{ styles=[];
  content= <:html<
    <h1>Networking
    <br />
     <small>here comes the RESTful bit</small>
    </h1>
    <p>Anil Madhavapeddy, Thomas Gazagnaire and David Scott</p>
  >>
};
{
  styles=[];
  content= <:html<
    <h3>Networking</h3>
    <ul>
      <li>Very similar to the block devices, except much more sensitive to latency.</li>
      <li>Xen provides Ethernet frames to the $github "lib/os/xen/netif.mli" "OS.Netif"$ driver, just as <tt>blkif</tt> provides sector-level access</li>
      <li>There are two separate shared rings: one for transmit, other for receive, and hardware offload options:</li>
    </ul>
<pre>
type features = {
  sg: bool;
  gso_tcpv4: bool;
  rx_copy: bool;
  rx_flip: bool;
  smart_poll: bool;
}
</pre>
  >>
};
{
  styles=[];
  content= <:html<
    <h3>Bring up the Network</h3>
    <p>Lets dive straight in, and bring up the Mirage network stack on UNIX. You will need <tt>tuntap</tt> on your OS (Linux or MacOS X).</p>
    <p>The bridge should have IP <tt>10.0.0.1</tt> as the applications default to <tt>10.0.0.2</tt>. Try not to bridge to the outside network!</p>
<pre class="noprettyprint">
$str:dl$ cd mirage-tutorial/examples/net/ping
$str:dl$ mir-build unix-direct/ping.ml
$str:dl$ sudo ./_build/unix-direct/ping.ml
// Another terminal
$str:dl$ ping 10.0.0.2
</pre>
<p>You should receive ICMP echo replies from the Mirage $github "lib/net/direct" "network stack"$!</p>
  >>
};

{
  styles=[];
  content= <:html<
    <h3>Ethernet and TCP/IP</h3>
    <ul>
      <li>The native OCaml implementation uses $github "lib/std/bitstring.mli" "Bitstring"$ to minimise data copying.</li>
      <li>Ethernet frames are parsed by $github "lib/net/direct/ethif.ml" "Net.Ethif"$, and $github "lib/net/direct/arp.ml" "Net.ARP"$ responses are sent.</li>
      <li>$github "lib/net/direct/nettypes.mli" "Nettypes"$ defines module signatures for <tt>DATAGRAM</tt> and <tt>CHANNEL</tt> as well as common types.</li>
      <li>There are simple implementations of $github "lib/net/direct/icmp.ml" "Net.ICMP"$ and $github "lib/net/direct/udp.mli" "UDP"$ (which implements <tt>DATAGRAM</tt> over IPv4).</li>
    </ul>
  >>
};
{ styles=[];
  content= <:html<
   <h3>DATAGRAM signature and UDPv4</h3>
<pre>
module type DATAGRAM = sig
  type mgr

  type src
  type dst

  type msg

  val recv : mgr -> src -> (dst -> msg -> unit Lwt.t) -> unit Lwt.t
  val send : mgr -> ?src:src -> dst -> msg -> unit Lwt.t
end

module UDPv4 : Nettypes.DATAGRAM with
      type mgr = Manager.t
  and type src = Nettypes.ipv4_src
  and type dst = Nettypes.ipv4_dst
  and type msg = Bitstring.t
</pre>
  >>
};
{ styles=[];
  content= <:html<
<h3>Lets Build a DNS Server</h3>
<pre class="noprettyprint">
$str:dl$ cd mirage-tutorial/examples/dns
$str:dl$ make
# different terminal
$str:dl$ dig @127.0.0.1 -p 5555 www.openmirage.org
$str:dl$ dig @127.0.0.1 -p 5555 txt www.openmirage.org
</pre>
<p>This builds the socket version, listening on port <tt>5555</tt> and localhost.</p>
<p>It uses UNIX kernel sockets and not the Mirage stack (useful for testing the higher level protocols).</p>
>>
};
{ styles=[];
  content= <:html<
  <h3>Building DNS combinations</h3>
 <p>The table from earlier should make more sense now. Try out as many variations as you can, remembering that the direct stack will listen on <tt>10.0.0.2</tt></p>
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
