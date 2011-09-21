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

