<!-- .slide: class="title" -->

# __[The Mirage Tutorial](http://tutorial.openmirage.org/)__

Anil Madhavapeddy <small>University of Cambridge</small>
[@avsm](http://twitter.com/avsm)

Richard Mortier <small>University of Cambridge</small>
[@mort\_\_\_](http://twitter.com/mort___)

[http://openmirage.org/](http://openmirage.org/)<br/>
[http://tutorial.openmirage.org/](http://tutorial.openmirage.org/)<br/>

<small>Work funded in part by the EU FP7 User-Centric Networking project.</small>
<img src="ucn-logo.png" width="400px" style="margin: 0px" />

<small>
  Press &lt;esc&gt; to view the slide index, and the &lt;arrow&gt; keys to
  navigate. <br />
  Slides are arranged in a 2D grid, with each vertical column
  corresponding to a single topic.
</small>


----

## Before We Begin...

If you would like to follow along with these examples,
you will need to:

+ install [OCaml](http://ocaml.org) and the [OPAM](https://opam.ocaml.org) package manager, e.g.:

      $ brew install ocaml opam
      $ eval `opam config env`
<!-- .element: class="no-highlight" -->

+ install Mirage:

      $ opam install mirage
<!-- .element: class="no-highlight" -->

More details, including instructions for non-OSX platforms, can be found on the
[MirageOS website](http://openmirage.org/wiki/install).


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
  <img src="decks-on-arm.png" />
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


----

## Overview

Let's look at some functional programming techniques that allow all this:

+ Co-operative threading via monadic concurrency;
+ Modular device drivers and applications
+ Configuration eDSL for flexible deployment
+ From a simple static website to a custom networking stack; and
+ How we use `git` and  CI to automate unikernel management.


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

The toplevel will report the following type:

```
module OptionMonad = sig
 type 'a t
 val bind : 'a t -> ('a -> 'b t) -> 'b t
 val return :  'a -> 'a t
end
```


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

Binds can be chained to link the results.

```
bind (
 bind
  (Some 1)
  (fun c -> return (c+1))
 ) (fun c -> return (c+1)) ;;
- : int option = Some 3
```


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

Or define a `maybe_add` function to be even more succinct.

```
let maybe_add c = return c + 1 ;;
val maybe_add : int -> int option = <fun>

return 1
>>= maybe_add
>>= maybe_add
- : int option = Some 3
```


## Monad Laws

```
module type MONAD = sig
 type 'a t
 val bind : 'a t -> ('a -> 'b t) -> 'b t
 val return :  'a -> 'a t
end
```

* Monad implementations must satisfy some laws.


## Laws: left identity

```
module type MONAD = sig
 type 'a t
 val bind : 'a t -> ('a -> 'b t) -> 'b t
 val return :  'a -> 'a t
end
```

`return` is a left identity for `bind`

```
return x >>= f
f x
```

Using the OptionMonad:

```
# return 1 >>= maybe_add ;;
- : int option = Some 2

# maybe_add 1;;
- : int option = Some 2

# return (Some 1) >>= maybe_add
```


## Laws: right identity

```
module type MONAD = sig
 type 'a t
 val bind : 'a t -> ('a -> 'b t) -> 'b t
 val return :  'a -> 'a t
end
```

`return` is a right identity for `bind`

```
m >>= return
m
```

Using the OptionMonad:

```
# Some 1 >>= return
- : int option = Some 1

# None >>= return
- : 'a option = None
```


## Monad Laws: associativity

```
module type MONAD = sig
 type 'a t
 val bind : 'a t -> ('a -> 'b t) -> 'b t
 val return :  'a -> 'a t
end
```

`bind` is associative (in an odd way).

```
(u >>= f) >>= g
u >>= (fun x -> f x) >>= g
```

Using the OptionMonad:

```
# Some 3 >>= maybe_add >>= maybe_add ;;
- : int option = Some 5

# Some 3 >>= (fun x -> maybe_add x >>= maybe_add) ;;
- : int option = Some 5
```


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

- This lets our sequential code be fully concurrent, without preemptive system threads.
- Number of threads limited only by OCaml heap size.


## Wakeners: running in Xen

Lwt uses the `select` system call in Unix, which blocks the process until some IO event (or a timeout) occurs.

**But how does this translate to Xen?**


## Wakeners: running in Xen

Lwt uses the `select` system call in Unix, which blocks the process until some IO event (or a timeout) occurs.

Xen has an equivalent *VM block instruction* which suspends the whole VM until a device interrupt or timeout.

> **processes in Unix** <=> **Virtual Machines in Xen**

> **`select` in Unix** <=> **block entire VM in Xen**

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

> **`select` in Unix** <=> **block entire VM in Xen**

Our Xen VM can use this abstraction for all its I/O and timing.

**Question: What is the major downside of this approach?**


----

## Modularity is Good

Mirage OS restructures all system components as __modules__:

1. A collection of __module types__, describing the structural "shapes" of the
   components of an operating system (e.g., device drivers)

2. A collection of independent __libraries implementing those module types__

As with all library OSs, only the required libraries are linked into the final
application.


## Functor Terminology

* **Haskell**: Functor is a type class that lets you map functions
over the parameterised type using fmap.

* **OCaml**: Similar concept, except that it operates over *modules*
(a collection of functions and types) instead of a single type.

  * OCaml functor is a module that is parameterised across other
    modules (see [Real World OCaml Chap 9](https://realworldocaml.org/v1/en/html/functors.html)).

  * Functors and modules are a separate language from the core OCaml language. *([A Modular Module System](http://caml.inria.fr/pub/papers/xleroy-modular_modules-jfp.pdf), Xavier Leroy in JFP 10(3):269-303, 2000)*.


## Modular to the max

Modules are used everywhere in Mirage to describe OS layers:

- For the __whole application/OS__: we've a full implementation of the network
  stack (including TLS) in OCaml

- Very __flexible approach__ for customising OS stacks for weird applications
  (e.g., HTTP over UPnP over UDP)

- Lots of __separate implementations__ of the module signatures: Unix, Xen
  microkernels, JavaScript, kernel modules, ...


## Module Types: Devices

```
module type DEVICE = sig

  type +'a io
  type t
  type id

  val id : t -> id

  val disconnect : t -> unit io

end
```
<!-- .element: class="no-highlight" -->

Generic interface to any device driver...


## Module Types: Flows

```
module type FLOW = sig

  type +'a io
  type buffer
  type flow

  val read : flow -> [`Ok of buffer | `Eof | `Error of exn ] io

  val write : flow -> buffer -> [`Ok of unit | `Eof | `Error of exn ] io

  val writev : flow -> buffer list -> [`Ok of unit | `Eof | `Error of exn ] io

end
```
<!-- .element: class="no-highlight" -->

...or IO flow


## Module Types: Inclusion

```
module type TCPV4 = sig

  type buffer
  type ipv4
  type ipv4addr
  type flow

  include DEVICE with
  with type id := ipv4

  include FLOW with
  with type 'a io  := 'a io
  and  type buffer := buffer
  and  type flow   := flow
```
<!-- .element: class="no-highlight" -->

...and they can be composed together into other module types, avoiding the
diamond problem


## Module Types: Entropy

```
module type ENTROPY = sig

  include DEVICE
  type buffer

  type handler = source:int -> buffer -> unit
  (** A [handler] is called whenever the system has extra entropy to announce.
   * No guarantees are made about the entropy itself, other than it being
   * environmentally derived. In particular, the amount of entropy in the buffer
   * can be far lower than the size of the [buffer].
   *
   * [source] is a small integer, describing the provider but with no other
   * meaning.
   **)

  val handler : t -> handler -> unit io
end
```
<!-- .element: class="no-highlight" -->

Complex driver models can be expressed abstractly (see
[V1.ml](https://github.com/mirage/mirage/tree/master/types/))


----

## Writing a component

A Mirage component usually contains:

- Code parameterised by functors with very limited (Mirage-only) dependencies,
  and particularly __no OS dependencies__

- A collection of libraries where the functors are applied,
  suitable for interactive use

> Functors clearly separate dependencies between OS components, breaking
> the monolithic OS down into components


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


## Example: These Slides

```
module Main (C:CONSOLE) (FS:KV_RO) (H:HTTP.Server) = struct

  let start c fs http =
    ...

    let callback conn_id request body =
      C.log "HTTP request received" ...
      >>= fun () ->
      let uri = H.Request.uri request in
      dispatcher (split_path uri)
    in
    let conn_closed (_,conn_id) () = ...  in
    http { H.callback; conn_closed }

end
```
<!-- .element: class="no-highlight" -->


## Deployment Options

There are several ways we might want to deploy this site:

* Standalone Xen unikernel with all data built into image.
* Xen unikernel with data dynamically read from a  block device.
* Unix binary with data passed through to filesystem.
* Unix binary with data passed in from a Docker volume.
* Unix binary with OCaml userlevel TCP/IP stack.

<br />
> The desired unikernel is constructed by writing OCaml code that
> applies concrete module implementations to the application functor.


## The Bad News

Functors are rather heavyweight constructs, and need to be applied in some concrete
combination to make an executable.

The module language is much more limited than the core host language, so we embed
it inside the host language as an eDSL.

> __Metaprogramming__:  manipulate functors as values in the
  host language, and emit resulting module applications as a program stage.


## Mirage eDSL: module types

To simplify building applications, we use an eDSL.

```
type 'a typ
(** The type of values representing module types. *)

val (@->): 'a typ -> 'b typ -> ('a -> 'b) typ
(** Construct a functor type from a type and an existing functor
    type. This corresponds to prepending a parameter to the list of
    functor parameters. For example,

    {| kv_ro @-> ip @-> kv_ro |}

    describes a functor type that accepts two arguments -- a kv_ro and
    an ip device -- and returns a kv_ro.
*)
```
<!-- .element: class="no-highlight" -->

This describes all the __module types__ (`NETWORK`, `TCPV4`, etc...)


## Mirage eDSL: module types

The eDSL also describes concrete module implementations for a given
signature (e.g. a socket TCPv4 stack vs direct OCaml one).

```
type 'a impl
(** The type of values representing module implementations. *)

val ($): ('a -> 'b) impl -> 'a impl -> 'b impl
(** [m $ a] applies the functor [a] to the functor [m]. *)

val foreign: string -> 'a typ -> 'a impl
(** [foreign name constr typ] states that the module named
    by [name] has the module type [typ]. *)

val typ: 'a impl -> 'a typ
(** Return the module signature of a given implementation. *)
```
<!-- .element: class="no-highlight" -->


## Your Server as a Function

Your web server configuration is setup via OCaml code.

```
# Build a web server listening on TCP port 80, logging to the default console 
let server =
  let conduit = conduit_direct (stack default_console) in
  http_server (`TCP (`Port 80)) conduit

# Build a job type that accepts a console, key/value store and an HTTP server *)
let slide_deck = foreign "Dispatch.Main"
  (console @-> kv_ro @-> http @-> job)

# Create a job instance
let () =
  register "www" [ slide_deck $ default_console $ fs $ server ]
```
<!-- .element: class="no-highlight" -->

The configuration is evaluated at compilation time to generate a main entry
point for that _particular_ setup


## Correspondence

Configuration Code:

```
let server =
  let conduit = conduit_direct (stack default_console) in
  http_server (`TCP (`Port 80)) conduit

let main = foreign "Dispatch.Main"
  (console @-> kv_ro @-> http @-> job)
```
<!-- .element: class="no-highlight" -->

Application Code:

```
module Main (C:CONSOLE) (FS:KV_RO) (H:HTTP.Server) = struct

  let start c fs http = ...
```
<!-- .element: class="no-highlight" -->


## Codegen: Unix

```
module Stackv41 = Tcpip_stack_socket.Make(Console)
module Conduit1 = Conduit_mirage.Make(Stackv41)
module Http1 = HTTP.Make(Conduit1)
module M1 = Dispatch.Main(Console)(Static1)(Http1.Server)
```
<!-- .element: class="no-highlight" -->

Fairly simple application where:

+ A kernel socket `C` binding, `Tcpip_stack_socket`, takes...
+ A `Console` to build...
+ A network stack, `Stackv41`, over which we instantiate...
+ An `HTTP` server

...which is finally passed to the application (along with a static filesystem
and a console)


## Codegen: Xen

```
module Stackv41 = struct
  module E = Ethif.Make(Netif)
  module I = Ipv4.Make(E)
  module U = Udpv4.Make(I)
  module T = Tcpv4.Flow.Make(I)(OS.Time)(Clock)(Random)
  module S = Tcpip_stack_direct.Make(Console)(OS.Time)(Random)(Netif)(E)(I)(U)(T)
  include S
end
module Conduit1 = Conduit_mirage.Make(Stackv41)
module Http1 = HTTP.Make(Conduit1)
module M1 = Dispatch.Main(Console)(Static1)(Http1.Server)

...

let () =
  OS.Main.run (join [t1 ()])
```
<!-- .element: class="no-highlight" -->

In Xen, we build the network stack "by hand" starting with the Ethernet device,
as we have no kernel sockets


## Module vs value language

- Error messages are significantly simpler in the host language (small type mismatches *vs* dumps of entire module signatures!)

- Optional arguments:

```
val direct_tcpv4:
  ?clock:clock impl ->
  ?random:random impl ->
  ?time:time impl ->
  ipv4 impl -> tcpv4 impl
```
<!-- .element: class="no-highlight" -->

Can select default module implementations for CLOCK, RANDOM and TIME to save manual work.


## Just like Dynamics

Dynamics is a pair between:

* a *value*
* a value that represents its *type*.

In the Mirage EDSL, an *impl* represents a triple of:

* a *typ*
* a CONFIGURABLE and the constructor function for the module.

GADTs ensure that an *impl* cannot be applied to a *typ* that does not admit it, so the resulting functor applications are sound.


## Configuration: Summary

* Unikernel is a **parameterised module** over dependencies.
  - ML functors separate OS functionality into modular chunks.
  - Mirage provides a large library of module types.
* **Metaprogramming** is used to manipulate these modules.
  - Mirage eDSL manipulates module types and implementations in OCaml.
  - Config file is interpreted to generate executable kernel.
  - Flexible way to specify precise device driver needs.
<!-- .element: class="no-highlight" -->


----

## A Simple Static Website

Following the console example, building a simple static website adds a couple of extra devices:

+ a __filesystem__, storing the data to be served; and
+ a __web server__, using a high-level abstraction over the network stack.

We'll now walk through the simple example from `mirage-skeleton/static_website`.


## `config.ml`: Filesystem

First, we determine the required filesystem configuration:

```
let fs =
  let mode = try match String.lowercase (Unix.getenv "FS") with
    | "fat" -> `Fat
    | _     -> `Crunch
    with Not_found -> `Crunch
  in
  let fat_ro dir = kv_ro_of_fs (fat_of_files ~dir ()) in
  match mode with
  | `Fat    -> fat_ro "./htdocs"
  | `Crunch -> crunch "./htdocs"
```
<!-- .element: class="no-highlight" -->


## `config.ml`: Network

Next we determine the network stack configuration:

```
let stack console =
  let net =
    try match Sys.getenv "NET" with
      | "direct" -> `Direct
      | "socket" -> `Socket
      | _        -> `Direct
    with Not_found -> `Direct
  in
  let dhcp =
    try match Sys.getenv "DHCP" with
      | "" -> false
      | _  -> true
    with Not_found -> false
  in
  match net, dhcp with
  | `Direct, true  -> direct_stackv4_with_dhcp console tap0
  | `Direct, false -> direct_stackv4_with_default_ipv4 console tap0
  | `Socket, _     -> socket_stackv4 console [Ipaddr.V4.any]
```
<!-- .element: class="no-highlight" -->


## `config.ml`: Server

Then we construct the `server` instance:

```
let port =
  try match Sys.getenv "PORT" with
    | "" -> 80
    | s  -> int_of_string s
  with Not_found -> 80

let server =
  http_server port (stack default_console)
```
<!-- .element: class="no-highlight" -->


## `config.ml`: Unikernel

Finally we stitch things together:

```
let main =
  foreign "Unikernel.Main" (console @-> kv_ro @-> http @-> job)

let () =
  add_to_ocamlfind_libraries ["re.str"];
  add_to_opam_packages ["re"];

  register "www" [
    main $ default_console $ fs $ server
  ]
```
<!-- .element: class="no-highlight" -->

Resulting in:

    $ NET={socket|direct} FS={fat|crunch} DHCP={true|false} PORT={n} \
        make configure
    $ make build
    $ make run
<!-- .element: class="no-highlight" -->


----

## Customising Your Stack

The static website example uses a high-level abstraction over the network stack (`STACKV4`).

Mirage's modularity means that you can construct customised network stacks easily too using the `direct` network stack!


## A More Complex Signature

```
module Main (C: CONSOLE) (N: NETWORK) = struct

  module E = Ethif.Make(N)
  module I = Ipv4.Make(E)
  module U = Udpv4.Make(I)
  module T = Tcpv4.Flow.Make(I)(OS.Time)(Clock)(Random)
  module D = Dhcp_clientv4.Make(C)(OS.Time)(Random)(E)(I)(U)
```

Also define a simple error handler:
```
  let or_error c name fn t =
    fn t
    >>= function
    | `Error e -> fail (Failure ("Error starting " ^ name))
    | `Ok t -> return t
```


## Constructing the Stack

Use the modules created above to construct concrete instances of the interfaces:
```
  let start c net =
    or_error c "Ethif" E.connect net
    >>= fun e ->

    or_error c "Ipv4" I.connect e
    >>= fun i ->
    I.set_ipv4 i (Ipaddr.V4.of_string_exn "10.0.0.2")
    >>= fun () ->
    I.set_ipv4_netmask i (Ipaddr.V4.of_string_exn "255.255.255.0")
    >>= fun () ->
    I.set_ipv4_gateways i [Ipaddr.V4.of_string_exn "10.0.0.1"]
    >>= fun () ->

    or_error c "UDPv4" U.connect i
    >>= fun udp ->

    let dhcp (* main thread *), offers (* async stream of offers *) = D.create c i udp in

    or_error c "TCPv4" T.connect i
    >>= fun tcp ->
```


## Handling Packets

```
    N.listen net (
      E.input e
        ~ipv4:(
          I.input i
            ~tcp:(
              T.input tcp ~listeners:
                (function
                  ...
                ))
            ~udp:(
              U.input udp ~listeners:
                (fun ~dst_port ->
                   C.log c (blue "udp packet on port %d" dst_port);
                   D.listen dhcp ~dst_port)
            )
            ~default:(fun ~proto ~src ~dst _ -> return ())
        )
        ~ipv6:(fun b -> C.log_s c (yellow "ipv6"))
    )
```


## Handling TCP Packets

```
   T.input tcp ~listeners:
     (function
       | 80 -> Some (fun flow ->
           let dst, dst_port = T.get_dest flow in
           C.log_s c
             (green "new tcp from %s %d" (Ipaddr.V4.to_string dst) dst_port)
           >>= fun () ->

           T.read flow
           >>= function
           | `Ok b ->
             C.log_s c
               (yellow "read: %d\n%s" (Cstruct.len b) (Cstruct.to_string b))
             >>= fun () ->
             T.close flow
           | `Eof -> C.log_s c (red "read: eof")
           | `Error e -> C.log_s c (red "read: error"))
       | _ -> None
     )
```


----

## OPAM automation

Libraries are the heart of Mirage, and OPAM manages this all: <https://opam.ocaml.org>

* Configuration eDSL knows which OPAM packages are needed.
* Staged compilation makes them available via `opam install`.
* Works beautifully with OPAM 1.2 workflows.
  * Git development via `opam pin`
  * Feature branches via `opam remote`
  * Create libraries via `opam publish`
  * Upgrade installation via `opam update`
  * _(soon!)_ Cross-referenced documentation via `opam doc`


## Modular Community (1)

Our protocol libraries are highly modular.  E.g., HTTP:

* __`Cohttp`__ portable parsing core in pure OCaml
* __`Cohttp_lwt`__ which adds concurrent I/O.
* __`Cohttp_lwt_unix`__ maps I/O to `Lwt_io` under Unix.
* __`Cohttp_lwt_mirage`__ adds further functors.
* __`Cohttp_async`__ uses Jane Street Core instead of Lwt.


## Modular Community (2)

And the best/worst for last...

* __`Cohttp_js`__ maps `Cohttp.Client` to JavaScript's XMLHTTPRequest!
* Existing OCaml Cohttp bindings (such as GitHub) compile straight to efficient JavaScript or native code.
* See [H261 video decoding](http://andrewray.github.io/iocamljs/oh261.html) using this.


----

## Orchestration

Deploying unikernels on the cloud is much like starting binaries in Unix.

+ Contain a *precise* manifest of source code dependencies.
+ Type-checking compiler sits between the source code and the cloud.


## Compiler in the Middle

<p class="stretch center">
  <img src="uniarch1a.png" />
</p>


## Compiler in the Middle

<p class="stretch center">
  <img src="uniarch1b.png" />
</p>


## Compiler in the Middle

<p class="stretch center">
  <img src="uniarch1c.png" />
</p>


## Compiler in the Middle

<p class="stretch center">
  <img src="uniarch1d.png" />
</p>


## Git Your Own Cloud

Unikernels are **small enough to be tracked in GitHub**. For example, for the
[Mirage website](http://openmirage.org/):

1. Source code updates are merged to **[mirage/mirage-www](https://github.com/mirage/mirage-www)**;

2. Repository is continuously rebuilt by
  **[Travis CI](https://travis-ci.org/mirage/mirage-www)**; if successful:

3. Unikernel pushed to  **[mirage/mirage-www-deployment](https://github.com/mirage/mirage-www-deployment)**;
  and our

4. Cloud toolstack spawns VMs based on pushes there.

**Our *entire* cloud-facing deployment is version-controlled from the source code
up**!


## Implications

**Historical tracking of source code and built binaries in Git(hub)**.

+ `git tag` to link code and binary across repositories.
+ `git log` to view deployment changelog.
+ `git pull` to deploy new version.
+ `git checkout` to go back in time to any point.
+ `git bisect` to pin down deployment failures.


## Implications

Historical tracking of source code and built binaries in Git(hub).

**Low latency deployment of security updates**.

+ No need for Linux distro to pick up and build the new version.
+ Updated binary automatically built and pushed.
+ Pick up latest binary directly from repository.
+ Statically type-checked language prevents classes of attack.


## Implications

Historical tracking of source code and built binaries in Git(hub).

Low latency deployment of security updates.

**Unified development for cloud and embedded environments**.

+ Write application code once.
+ Recompile to swap in different versions of system libraries.
+ Use compiler optimisations for exotic environments.


## Wrapping Up

Mirage OS 2.0 is an important step forward, supporting **more**, and **more
diverse**, **backends** with much **greater modularity**.

For information about the many components we could not cover here, see
[openmirage.org](http://openmirage.org/blog/):

+ __[Irmin](http://openmirage.org/blog/introducing-irmin)__, Git-like
  distributed branchable storage.
+ __[OCaml-TLS](http://openmirage.org/blog/introducing-ocaml-tls)__, a
  from-scratch native OCaml TLS stack.
+ __[Vchan](http://openmirage.org/blog/update-on-vchan)__, for low-latency
  inter-VM communication.
+ __[Ctypes](http://openmirage.org/blog/modular-foreign-function-bindings)__,
  modular C foreign function bindings.
