<!-- .slide: class="title" -->

# __[The Mirage Tutorial](http://tutorial.openmirage.org/)__

Richard Mortier <small>University of Nottingham</small>
[@mort\_\_\_](http://twitter.com/mort___)

Anil Madhavapeddy <small>University of Cambridge</small>
[@avsm](http://twitter.com/avsm)

[http://openmirage.org/](http://openmirage.org/)<br/>

<small>
  Press &lt;esc&gt; to view the slide index, and the &lt;arrow&gt; keys to
  navigate. <br />
  Slides are arranged in a 2D grid, with each vertical column
  corresponding to a single topic.
</small>


----

## Before We Begin...

If you would like to follow along with these examples (and we recommend you do!)
you will need to:

+ install OCaml and the `opam` package manager, e.g.:

      $ brew install ocaml opam
      $ eval `opam config env`
<!-- .element: class="no-highlight" -->

+ install Mirage:

      $ opam install mirage
<!-- .element: class="no-highlight" -->

More details, including instructions for non-OSX platforms, can be found on the
[OpenMirage website](http://openmirage.org/wiki/install).


## Samples

You can also grab copies of all the samples used in this tutorial by cloning the
appropriate repositories:

      $ git clone https://github.com/mirage/mirage-tutorial
      $ git clone https://github.com/mirage/mirage-skeleton
<!-- .element: class="no-highlight" -->

The former contains this slide deck and the associated IOCaml notebooks; the
latter contains extensive working sample code, including all the examples we
will present, and more!

If you wish to run the IOCaml notebooks yourself, you will also need to install
IOCaml and point it to them:

      $ opam install iocaml
      $ iocaml -completion mirage-tutorial/notebooks
<!-- .element: class="no-highlight" -->


----

## Introducing [Mirage OS 2.0](http://openmirage.org/)

These slides were written using Mirage on OSX:

- They are hosted in a **938kB Xen unikernel** written in statically type-safe
  OCaml, including device drivers and network stack.

- Their application logic is just a **couple of source files**, written
  independently of any OS dependencies.

- Running on an **ARM** CubieBoard2, and hosted on the cloud.

- Binaries small enough to track the **entire deployment** in Git!


## Introducing [Mirage OS 2.0](http://openmirage.org/)

<p class="stretch center">
  <img src="decks-on-arm.jpg" />
</p>


## Leaning Tower of Cloud

<div class="left" style="width: 65%">
  <p>Numerous pain points:</p>
  <ul>
    <li>**Complex** configuration management.</li>
    <li>Duplicated functionality leads to **inefficiency**.</li>
    <li>VM image size leads to **long boot times**.</li>
    <li>Lots of code means a **large attack surface**.</li>
  </ul>
</div>

<p class="right">
  <img class="right" src="pisa.jpg" />
  <br />
  <small class="right">
    https://flic.kr/p/8N1hWh
  </small>
</p>


## Complexity Kills You

The enemy is **complexity**:

+ Applications are **deeply intertwined** with system APIs, and so lack
  portability.

+ Modern operating systems offer **dynamic support** for **many users** to run
  **multiple applications** simultaneously.

Almost unbounded scope for uncontrolled interaction!

<!-- .element: class="fragment" data-fragment-index="1" -->

+ Choices of distribution and version.
+ Ad hoc application configuration under `/etc/`
+ Platform configuration details, e.g., firewalls.

<!-- .element: class="fragment" data-fragment-index="1" -->


## Docker: Containerisation

<p class="stretch center">
  <img src="container.jpg" />
</p>
<p>
  <small class="right">
    https://flic.kr/p/qSbck
  </small>
</p>


## Docker: Containerisation

Docker bundles up all this state making it easy to transport, install and manage.

<p class="stretch center">
  <img src="stack-docker.png" />
</p>


## Can We Do Better?

**Disentangle applications from the operating system**.

- Break up operating system functionality into modular libraries.

- Link only the system functionality your app needs.

- Target alternative platforms from a single codebase.


----

## The Unikernel Approach

> Unikernels are specialised virtual machine images compiled from the full stack
> of application code, system libraries and config

<br/>
This means they realise several benefits:
<!-- .element: class="fragment" data-fragment-index="1" -->

+ __Contained__, simplifying deployment and management.
+ __Compact__, reducing attack surface and boot times.
+ __Efficient__, able to fit 10,000s onto a single host.

<!-- .element: class="fragment" data-fragment-index="1" -->


## It's All Just Source Code

Capture system dependencies in code and compile them away.<br/>
<span class="right" style="width: 15em">
  &nbsp;
</span>

<p class="stretch center">
  <img src="stack-abstract.png" />
</p>


## Retarget By Recompiling

Swap system libraries to target different platforms:<br/>
<span class="right">**develop application logic using native Unix**.</span>

<p class="stretch center">
  <img src="stack-unix.png" />
</p>


## Retarget By Recompiling

Swap system libraries to target different platforms:<br/>
<span class="right">**test unikernel using Mirage system libraries**.</span>

<p class="stretch center">
  <img src="stack-unix-direct.png" />
</p>


## Retarget By Recompiling

Swap system libraries to target different platforms:<br/>
<span class="right">**deploy by specialising unikernel to Xen**.</span>

<p class="stretch center">
  <img src="stack-x86.png" />
</p>


## End Result?

Unikernels are compact enough to boot and respond to network traffic in
real-time.

<table style="border-bottom: 1px black solid">
  <thead style="font-weight: bold">
    <td style="border-bottom: 1px black solid; width: 15em">Appliance</td>
    <td style="border-bottom: 1px black solid">Standard Build</td>
    <td style="border-bottom: 1px black solid">Dead Code Elimination</td>
  </thead>
  <tbody>
    <tr style="background-color: rgba(0, 0, 1, 0.2)">
      <td>DNS</td><td>0.449 MB</td><td>0.184 MB</td>
    </tr>
    <tr>
      <td>Web Server</td><td>0.674 MB</td><td>0.172 MB</td>
    </tr>
    <tr style="background-color: rgba(0, 0, 1, 0.2)">
      <td>Openflow learning switch</td><td>0.393 MB</td><td>0.164 MB</td>
    </tr>
    <tr>
      <td>Openflow controller</td><td>0.392 MB</td><td>0.168 MB</td>
    </tr>
  </tbody>
</table>


## End Result?

Unikernels are compact enough to boot and respond to network traffic in
real-time.

<img src="boot-time.png" />


----

## Mirage OS 2.0 Workflow

As easy as 1&mdash;2&mdash;3!

1. Write your OCaml application using the Mirage module types.
   + Express its configuration as OCaml code too!

           $ mirage configure config.ml --unix
<!-- .element: class="no-highlight" -->


## Mirage OS 2.0 Workflow

As easy as 1&mdash;2&mdash;3!

1. Write your OCaml application using the Mirage module types.
   + Express its configuration as OCaml code too!

2. Compile it and debug under Unix using the `mirage` tool.

         $ make depend # install library dependencies
         $ make build  # build the unikernel
         $ make run    # ==> sudo ./_build/main.native
<!-- .element: class="no-highlight" -->


## Mirage OS 2.0 Workflow

As easy as 1&mdash;2&mdash;3!

1. Write your OCaml application using the Mirage module types.
   + Express its configuration as OCaml code too!

2. Compile it and debug under Unix using the `mirage` tool.

3. Once debugged, simply retarget it to Xen, and rebuild!

          $ mirage configure config.ml --xen
          $ make depend && make build
          [ edit the .xl config and start your VM ]
<!-- .element: class="no-highlight" -->

   + All the magic happens via the OCaml module system.


## Modularizing the OS

<p class="stretch center">
  <img src="modules1.png" />
</p>


## Modularizing the OS

<p class="stretch center">
  <img src="modules2.png" />
</p>


## Modularizing the OS

<p class="stretch center">
  <img src="modules3.png" />
</p>


----

## <http://openmirage.org/>

Featuring blog posts by:
[Amir Chaudhry](http://amirchaudhry.com/),
[Thomas Gazagnaire](http://gazagnaire.org/),
[David Kaloper](https://github.com/pqwy),
[Thomas Leonard](http://roscidus.com/blog/),
[Jon Ludlam](http://twitter.com/jonludlam),
[Hannes Mehnert](https://github.com/hannesm),
[Mindy Preston](https://github.com/yomimono),
[Dave Scott](http://dave.recoil.org/),
and [Jeremy Yallop](https://github.com/yallop).

<p style="font-size: 48px; font-weight: bold;
          display: float; padding: 4ex 0; text-align: center">
  Thanks for listening!
  <br/>
  Any questions before we continue?
</p>


----

## Overview

We'll now take you through several core components of Mirage, specifically:

+ `Lwt`, the co-operative threading library used throughout Mirage;
+ `config.ml`, specifying a unikernel;
+ __Networking__, from a simple static website to a custom networking stack;


----

## Monads

```
module type MONAD = sig
 type 'a t
 val bind : 'a t -> ('a -> 'b t) -> 'b t
 val return :  'a -> 'a t
end
```
<!-- .element: class="no-highlight" -->

* A monad is a box that contains an abstract value.
* Put values in the box with `return`
* Transform them into other values with `bind`


## The Option Monad

Let's implement a monad that expresses optional values, starting in the OCaml interactive toplevel.

```
# Some "apple" ;;
- : string option = Some "apple"

# None ;;
- : 'a option = None

# let return x = Some x ;;
val return : 'a -> 'a option = <fun>

# let maybe u f =
 match u with
 | Some c -> f c
 | None   -> None ;;
val maybe : 'a option -> ('a -> 'b option) -> 'b option = <fun>
```
<!-- .element: class="no-highlight" -->


## Option Monad: definition

```
module OptionMonad = struct
  type 'a t = 'a option

  let bind u f =
   match f with
   | Some x -> f x
   | None   -> None

  let return u = Some u
end
```
<!-- .element: class="no-highlight" -->

The toplevel will report the following type:

```
module OptionMonad = sig
 type 'a t
 val bind : 'a t -> ('a -> 'b t) -> 'b t
 val return :  'a -> 'a t
end
```
<!-- .element: class="no-highlight" -->


## Option Monad: definition

```
module OptionMonad = struct
  type 'a t = 'a option

  let bind u f =
   match f with
   | Some x -> f x
   | None   -> None

  let return u = Some u
end
```
<!-- .element: class="no-highlight" -->

- The value in the box may not exist: `type 'a option`
- `return` places a concrete value in the box.
- `bind` applies a function if it exists or does nothing.

- Note: `f x` application in `bind` is *not* wrapped in `Some`.


## Option Monad: examples

Some simple uses of these definitions:

```
open OptionMonad ;;
bind
 (return 1)
 (fun c -> return (c+1)) ;;
- : int option = Some 2

bind
  None
  (fun c -> return (c+1)) ;;
- : int option = None
```
<!-- .element: class="no-highlight" -->

Binds can be chained to link the results.

```
bind (
 bind
  (Some 1)
  (fun c -> return (c+1))
 ) (fun c -> return (c+1)) ;;
- : int option = Some 3
```
<!-- .element: class="no-highlight" -->


## Option Monad: infix

Infix operators make chaining `bind` more natural:

```
let (>>=) = bind ;;
val ( >>= ) : 'a option -> ('a -> 'b option) -> 'b option = <fun>

return 1 >>= fun c ->
return (c+1) >>= fun c ->
return (c+1) ;;
- : int option = Some 3
```
<!-- .element: class="no-highlight" -->


## Option Monad: infix 

Infix operators make chaining `bind` more natural:

```
let (>>=) = bind ;;
val ( >>= ) : 'a option -> ('a -> 'b option) -> 'b option = <fun>

return 1 >>= fun c ->
return (c+1) >>= fun c ->
return (c+1) ;;
- : int option = Some 3
```
<!-- .element: class="no-highlight" -->

Or define a `maybe_add` function to be even more succinct.

```
let maybe_add c = return c + 1 ;;
val maybe_add : int -> int option = <fun>

return 1
>>= maybe_add
>>= maybe_add
- : int option = Some 3
```
<!-- .element: class="no-highlight" -->


## Monad Laws

```
module type MONAD = sig
 type 'a t
 val bind : 'a t -> ('a -> 'b t) -> 'b t
 val return :  'a -> 'a t
end
```
<!-- .element: class="no-highlight" -->

* Monad implementations must satisfy some laws.


## Monad Laws: left identity

```
module type MONAD = sig
 type 'a t
 val bind : 'a t -> ('a -> 'b t) -> 'b t
 val return :  'a -> 'a t
end
```
<!-- .element: class="no-highlight" -->

`return` is a left identity for `bind`

```
return x >>= f
f x
```
<!-- .element: class="no-highlight" -->

Using the OptionMonad:

```
# return 1 >>= maybe_add ;;
- : int option = Some 2

# maybe_add 1;;
- : int option = Some 2

# return (Some 1) >>= maybe_add
```
<!-- .element: class="no-highlight" -->


## Monad Laws: right identity

```
module type MONAD = sig
 type 'a t
 val bind : 'a t -> ('a -> 'b t) -> 'b t
 val return :  'a -> 'a t
end
```
<!-- .element: class="no-highlight" -->

`return` is a right identity for `bind`

```
m >>= return
m
```
<!-- .element: class="no-highlight" -->

Using the OptionMonad:

```
# Some 1 >>= return
- : int option = Some 1

# None >>= return
- : 'a option = None
```
<!-- .element: class="no-highlight" -->


## Monad Laws: associativity

```
module type MONAD = sig
 type 'a t
 val bind : 'a t -> ('a -> 'b t) -> 'b t
 val return :  'a -> 'a t
end
```
<!-- .element: class="no-highlight" -->

`bind` is associative (in an odd way).

```
(u >>= f) >>= g
u >>= (fun x -> f x) >>= g
```
<!-- .element: class="no-highlight" -->

Using the OptionMonad:

```
# Some 3 >>= maybe_add >>= maybe_add ;;
- : int option = Some 5

# Some 3 >>= (fun x -> maybe_add x >>= maybe_add) ;;
- : int option = Some 5
```
<!-- .element: class="no-highlight" -->


----

## Cooperative Concurrency

There are quite a few uses for monads; we'll use this to build a cooperative concurrency model for our OS.

```
module Lwt = struct
 type 'a t
 val bind : 'a t -> ('a -> 'b t) -> 'b t
 val return :  'a -> 'a t
end
```
<!-- .element: class="no-highlight" -->

The `Lwt` (Light Weight Thread) monad signature above represents a *future computation* that is held in the box.

Can construct *futures* and compute using them by using `bind` to operate over its eventual value.


## Constant threads

```
open Lwt ;;
let future_int = return 1 ;;
val future_int : int Lwt.t = <abstr>
```
<!-- .element: class="no-highlight" -->

Build a constant thread by using `return`.

```
let future_fruit = return "apple" ;;
val future_fruit : string Lwt.t = <abstr>

let future_lang = return `OCaml ;;
val future_lang : [> `OCaml] Lwt.t = <abstr>
```
<!-- .element: class="no-highlight" -->

Threads are first-class OCaml values and parametric polymorphism lets you
distinguish different types of threads.

No system threads are involved at all; this is sequential code.


## Concurrency: executing

```
module OS = struct
 val sleep : float -> unit Lwt.t
 val run : 'a Lwt.t -> 'a
end
```
<!-- .element: class="no-highlight" -->

The monad needs to be *executed* to retrieve the future contents.


## Concurrency: executing

```
module OS = struct
 val sleep : float -> unit Lwt.t
 val run : 'a Lwt.t -> 'a
end
```
<!-- .element: class="no-highlight" -->

The monad needs to be *executed* to retrieve the future contents.

```
let t =
 OS.sleep 1.0 >>= fun () ->
 print_endline ">> start";
 OS.sleep 2.0 >>= fun () ->
 print_endline ">> woken up";
 return () ;;
val t : unit Lwt.t = <abstr>
```
<!-- .element: class="no-highlight" -->


## Concurrency: executing

```
module OS = struct
 val sleep : float -> unit Lwt.t
 val run : 'a Lwt.t -> 'a
end
```
<!-- .element: class="no-highlight" -->

The monad needs to be *executed* to retrieve the future contents.

```
let t =
 OS.sleep 1.0 >>= fun () ->
 print_endline ">> start";
 OS.sleep 2.0 >>= fun () ->
 print_endline ">> woken up";
 return () ;;
val t : unit Lwt.t = <abstr>

OS.run t ;;
>> start
>> woken up
```
<!-- .element: class="no-highlight" -->

The `run` function takes a future and unpacks the real value.


## Joinad: not quite a monad

```
module Lwt = struct
 type 'a t
 val bind : 'a t -> ('a -> 'b t) -> 'b t
 val return :  'a -> 'a t

 val join : unit t list -> unit t
 val choose : 'a t list -> 'a t
end
```
<!-- .element: class="no-highlight" -->

We extend the `MONAD` signature with:

- `join` to wait for a list of threads to terminate.
- `choose` to return as soon as one thread of a list completes.
- `join` aliased to `<&>` operator and `choose` as `<?>`.

<br/>
*(see [tomasp.net](http://tomasp.net) and [tryjoinads.org](http://tryjoinads.org) for more background)*


## Example: flip a coin

```
module Lwt = struct
 type 'a t
 val bind : 'a t -> ('a -> 'b t) -> 'b t
 val return :  'a -> 'a t

 val join : unit t list -> unit t
 val choose : 'a t list -> 'a t
end
```
<!-- .element: class="no-highlight" -->

Using `choose` to pick the first thread in a coin flip:

```
let flip_a_coin () =
 let heads =
  OS.sleep 1.0 >>= fun () ->
  return (OS.log "Heads") in
 let tails =
  OS.sleep 2.0 >>= fun () ->
  return (OS.log "Tails") in
 heads <&> tails
```
<!-- .element: class="no-highlight" -->


## Thread representation

```
type 'a t = {
 | Return of 'a
 | Fail of exn
 | Sleep of 'a sleeper
}
and sleeper = {
 waiters : 'a waiter_set;
 <...etc>
}
```
<!-- .element: class="no-highlight" -->

Thread has three main states:

- It has **completed** and contains a concrete `Return` value.
- It has **failed** and contains a concrete `Fail` exception.
- It is **blocked** and waiting on another thread.


## Wakeners and tasks

Each thread executes until it needs to wait on a resource.  It creates
a *task* to let it be woken up in the future.

```
type 'a t  (* thread *)
type 'a u  (* wakener *)
val wait : unit -> 'a t * 'a u
val wakeup : 'a u -> 'a -> unit
```
<!-- .element: class="no-highlight" -->


## Wakeners and tasks

Each thread executes until it needs to wait on a resource.  It creates
a *task* to let it be woken up in the future.

```
type 'a t  (* thread *)
type 'a u  (* wakener *)
val wait : unit -> 'a t * 'a u
val wakeup : 'a u -> 'a -> unit
```
<!-- .element: class="no-highlight" -->

Tasks are a pair: a thread that sleeps until it is fulfilled via its wakener by calling `wakeup` on it.

```
let t1 =
 t >>= fun x ->
 print_endline x;
 return ()
and t2 =
 OS.sleep 2.0 >>= fun () ->
 wakeup u "x";
 return ()
```
<!-- .element: class="no-highlight" -->


## Wakeners: building a timer

Wakeners are enough to build our `OS.sleep` function:

- Call `sleep` with `t` seconds as an argument.
- Create a thread `t` and a wakener `u`.
- Insert `u` into a priority queue ordered by timeout duration.
- Sleep on `t` until `u` is invoked by the scheduler.

Priority queue is a standard data structure ordered by duration.

```
module Sleep_queue =
 Lwt_pqueue.Make(struct
  type t = sleeper
  let compare { time = t1 } { time = t2 } = compare t1 t2
 end)
end
```
<!-- .element: class="no-highlight" -->


## Wakeners: running in Unix

`OS.main` runs until all threads are blocked,
and then drops into the `select` function to wait for the next timeout.

```
run main thread (threads register timeouts)
if result is Blocked then
 T = head of priority queue
 select() for T seconds
 wakeup timeouts
repeat until main thread result is Done or Fail
```
<!-- .element: class="no-highlight" -->

- This lets our sequential code be fully concurrent, without preemptive system threads.
- Number of threads limited only by OCaml heap size.


## Wakeners: running in Xen

Lwt uses the `select` system call in Unix, which blocks the process until some IO event (or a timeout) occurs.

**But how does this translate to Xen?**


## Wakeners: running in Xen

Lwt uses the `select` system call in Unix, which blocks the process until some IO event (or a timeout) occurs.

Xen has an equivalent *VM block instruction* which suspends the whole VM until a device interrupt or timeout.

> **processes in Unix** <=> **Virtual Machines in Xen**

> **`select` in Unix** <=> **block entire virtual machine in Xen**

```
module OS = struct
 val sleep : float -> unit Lwt.t
 val run : 'a Lwt.t -> 'a
end
```
<!-- .element: class="no-highlight" -->


## Wakeners: running in Xen

Lwt uses the `select` system call in Unix, which blocks the process until some IO event (or a timeout) occurs.

Xen has an equivalent *VM block instruction* which suspends the whole VM until a device interrupt or timeout.

> **processes in Unix** <=> **Virtual Machines in Xen**

> **`select` in Unix** <=> **block entire virtual machine in Xen**

Our Xen VM can use this abstraction for all its I/O and timing.

**Question: What is the major downside of this approach?**

----
