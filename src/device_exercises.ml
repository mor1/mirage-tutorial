open Lwt
open Cow
open Printf
open Slides

let rt = ">>" (* required to embed it in html p4 as cant put that token directly there *)
let dl = "$"
let slides = [
{ styles=[];
  content= <:html<
    <h1>Device Model Exercises
    <br />
     <small>taptaptap, is this thing on?</small>
    </h1>
    <p>Anil Madhavapeddy and David Scott</p>
  >>
};
{ styles=[];
  content= <:html<
    <h3>Using Key-Value Stores</h3>
    <p>To add a key-value store, we just need a provider that implements the $github "lib/os/unix/devices.mli" "kv_ro"$ interface. The simplest provider is really simple. Lets try it now!</p>
<pre class="noprettyprint">
$str:dl$ cd mirage-tutorial/examples/devices/crunch
$str:dl$ echo 12345 > static/foo
$str:dl$ echo 67890 > static/bar
$str:dl$ mir-crunch -name myblock static > filesystem_static.ml
$str:dl$ vi filesystem_static.ml
</pre>
<p>It is an ML module that statically serves the filesystem from memory. Notice the provider code at the bottom that registers the device with the <tt>id</tt> you specified to <tt>mir-crunch</tt>.</p>
  >>
};
{ styles=[];
  content= <:html<
   <h3>Using Key-Value Stores (2)</h3>
   <p>Now create a <tt>server.ml</tt> file that will read the file <tt>foo</tt> from our built-in block store:</p>
<pre>
open Lwt
open Printf

let main () =
  printf "Plugging device\n%!";
  lwt kv_ro = OS.Devices.with_kv_ro "myblock" return in
  printf "Reading file foo\n%!";
  match_lwt kv_ro#read "foo" with
  |Some s ->
    printf "File contents:\n%!";
    Lwt_stream.iter (fun b ->
      printf "%s%!" (Bitstring.string_of_bitstring b);
    ) s
  |None ->
    printf "File not found\n%!";
    return ()
</pre>
  >>
};
{ styles=[];
  content= <:html<
   <h3>Using Key-Value Stores (3)</h3>
   <p>Now we need to link our fake block device <tt>Filesystem_static</tt> into our Mirage application. The <tt>server.mir</tt> file lets you control the build:</p>
<pre class="noprettyprint">
$str:dl$ echo Server.main &gt; kv_crunch.mir
$str:dl$ echo Filesystem_static &gt;&gt; kv_crunch.mir
</pre>
<p>The first line defines the entry module and function to start the main Lwt thread. The remaining lines specify additional modules to link in, in this case our fake filesystem.</p>
<pre class="noprettyprint">
$str:dl$ mir-build unix-socket/kv_crunch.bin
$str:dl$ ./_build/unix-socket/kv_crunch.bin
</pre>
<p>Try reading <tt>bar</tt> too, or examining the output of:<br /><tt>mir-build unix-socket/server.pp.ml</tt></p>
>>
};
{ styles=[];
  content= <:html<
   <h3>A UNIX Filesystem Bridge</h3>
   <p>Would like to avoid recompiling on UNIX every time we change a file.</p>
   <p>Replace the <tt>Filesystem_static</tt> with $github "lib/block/socket/simpleKV.ml" "Block.SimpleKV"$</p>
<pre class="noprettyprint">
$str:dl$ echo Server.main &gt; kv_fs.mir
$str:dl$ echo Block.SimpleKV &gt;&gt; kv_fs.mir
$str:dl$ mir-build unix-socket/kv_fs.bin
$str:dl$ ./_build/unix-socket/kv_fs.bin -simple_kv_ro myblock:static
</pre>
<p>The <b><tt>-simple_kv_ro</tt></b> flag is of form <b><tt>devid:root_dir</tt></b></p>
<p>The provider maps the filesystem as a k/v store. Notice that no changes were required to your original source!</p>
<p>Advanced? Try a loop that retries a file read every few seconds, and alter the filesystem.</p>
>>
};
{ styles=[];
  content= <:html<
    <h3>A Raw Block Device</h3>
    <p>The <tt>unix-direct</tt> backend lets us build ML filesystems over raw disk images.</p>
    <p>The <b>$github "tools/fs" "mir-fs-create"$</b> tool converts a directory to a disk image, which is readable by the <tt>unix-direct</tt> version of $github "lib/block/direct/simpleKV.ml" "Block.SimpleKV"$</p>
<pre class="noprettyprint">
$str:dl$ dd if=/dev/zero of=disk1.img count=4096
$str:dl$ mir-fs-create static disk1.img
$str:dl$ mir-build unix-direct/kv_fs.bin
$str:dl$ ./_build/unix-direct/kv_fs.bin -vbd myvbd:disk1.img \
  -simple_kv_ro myblock:myvbd
</pre>
<p>The <b><tt>-vbd</tt></b> flag maps in a block device, and the <br />
<b><tt>-simple_kv_ro</tt></b> flag now accepts a VBD ID to mount.</p>
<p><b>Advanced? </b>Try <tt>hexdump</tt> on <tt>disk1.img</tt>.</p>

>>

};

{ styles=[];

  content= <:html<

   <h3>Standalone Xen</h3>

   <p>With a RAMdisk (<tt>kv_crunch</tt>, the first example), the Xen
   microkernel with storage is trivial.</p>

<pre class="noprettyprint">
// Linux x86_64 only
$str:dl$ mir-build xen/kv_crunch.xen
$str:dl$ mir-run -b xen _build/xen/kv_crunch.xen
</pre>

<p>You can spend most of your time debugging using
  <tt>unix-direct</tt>, and only swap to Xen for wider testing and
      deployment.</p>

<p>The rich development environment of UNIX, and the microkernel
      advantages in production, without changing a line of code!</p>

  >>

};

{ styles=[];

  content= <:html<

   <h3>FAT Filesystems</h3>

   <p>Mirage has a succinct ML implementation of the FAT filesystem in
   $github "lib/fs" "Fs.Fat"$.</p>

<pre class="noprettyprint">
$str:dl$ cd mirage-tutorial/devices/fat
$str:dl$ make
</pre>



<p>The command-line flag to map a FAT image is <br />

<b><tt>-fat_kv_ro id:blkif_id</tt></b> just like the previous one.</p>

<p>This is for advanced users, but see what you can do with it! MacOS
    has poor support for manipulating FAT volumes, so this will be
      easier on Linux.</p>



>>

};

]


