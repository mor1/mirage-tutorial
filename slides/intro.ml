open Lwt
open Cow
open Printf
open Slides

let rt = ">>" (* required to embed it in html p4 as cant put that token directly there *)
let dl = "$"
let pres = "background-color:#ddddff"
let activity = "background-color:#ffdddd"
let rest = "background-color:#ddffdd"

let slides = [
{
  styles=[];
  content= <:html<
    <h3>Your Tutorial Teachers Are...</h3>
    <ul>
     <li>
       <b>Dr. Anil Madhavapeddy</b>,<br />
       <div style="font-size: 80%">
       Senior Research Fellow,<br />
       Computer Laboratory, University of Cambridge.<br />
       <a href="http://anil.recoil.org/">http://anil.recoil.org</a>
       </div>
     </li>
       
     <li><b>Dr. David Scott</b>,<br />
       <div style="font-size: 80%">
       XenServer Platform Architect,<br />
       Citrix and Xen.org.<br />
       <a href="http://dave.recoil.org/">http://dave.recoil.org</a>
       </div>
     </li>
     <li><b>Dr. Thomas Gazagnaire</b>,
       <div style="font-size: 80%">
       CTO, OCamlPro.<br />
       <a href="http://thomas.gazagnaire.org/">http://gazagnaire.org</a>
       </div>
     </li>
    </ul>
    <p>With lots of contributions from Richard Mortier, Raphael Proust and Balraj Singh, who couldn't make it to Tokyo.</p>
  >>
};
{
  styles=[];
  content= <:html<
    <h3>Schedule</h3>
    <table>
      <tr style="background-color:#000; color:#EEE">
         <th>Topic</th>
         <th>Activity</th>
         <th>Time</th>
      </tr>
      <tr style=$str:pres$>
         <td>What is Mirage?</td>
         <td>Presentation</td>
         <td>10 mins</td>
      </tr>
      <tr style=$str:activity$>
         <td>Hello World in UNIX, Xen, Javascript</td>
         <td>Activity</td>
         <td>15 mins</td>
      </tr>
      <tr style=$str:pres$>
         <td>Threading Intro</td>
         <td>Presentation</td>
         <td>10 mins</td>
      </tr>
      <tr style=$str:activity$>
         <td>Threading Exercises</td>
         <td>Activity</td>
         <td>15 mins</td>
      </tr>
      <tr style=$str:rest$>
         <td colspan="2">Comfort Break</td>
         <td>10 mins</td>
      </tr>
      <tr style=$str:pres$>
         <td>Device Model and Storage</td>
         <td>Presentation</td>
         <td>10 mins</td>
      </tr>
      <tr style=$str:activity$>
         <td>File System Exercises</td>
         <td>Activity</td>
         <td>15 mins</td>
      </tr>
      <tr style=$str:pres$>
         <td>Syntax Extensions</td>
         <td>Presentation</td>
         <td>5 mins</td>
      </tr>
      <tr style=$str:rest$>
         <td colspan="2">Tea Break</td>
         <td>30 mins</td>
      </tr>
      <tr style=$str:pres$>
         <td>Networking</td>
         <td>Presentation</td>
         <td>10 mins</td>
      </tr>
      <tr style=$str:activity$>
         <td>Build Your Website</td>
         <td>Activity</td>
         <td>15 mins</td>
      </tr>
      <tr style=$str:pres$>
         <td>To the Cloud!</td>
         <td>Presentation</td>
         <td>10 mins</td>
      </tr>
      <tr style=$str:activity$>
         <td>Play with EC2</td>
         <td>Activity</td>
         <td>15 mins</td>
      </tr>
      <tr style=$str:rest$>
         <td colspan="2">Discussion</td>
         <td>10 mins</td>
      </tr>
    </table>
  >>
};
{
  styles=[];
  content= <:html<
    <h3>Prior Knowledge</h3>
    <ul>
      <li>Basic OCaml</li>
      <li>Day-to-day UNIX operation, preferably Linux or MacOS X.</li>
      <li>Version control (git)</li>
    </ul>
    <p><b>Does everyone have the VirtualBox VM installed?</b></p><br />
    <h3>Software Required</h3>
    <ul>
     <li>A 64-bit UNIX (Linux or MacOS X)</li>
     <li>OCaml 3.12.0 (with <tt>make world opt.opt</tt> to have the native code compilers)</li>
     <li><tt>tuntap</tt> (default on Linux, <a href="http://tuntaposx.sourceforge.net/">download</a> on MacOS X)</li>
     <li>Git checkout of <a href="http://github.com/avsm/mirage/">http://github.com/avsm/mirage</a></li>
    </ul>
  >>
};
]
