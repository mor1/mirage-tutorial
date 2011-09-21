open Lwt
open Printf

let main () =
  Log.info "Kv_ro" "Plugging device";
  lwt kv_ro = 
    match_lwt OS.Devices.find_kv_ro "static" with
      | None   -> raise_lwt (Failure "no kv_ro")
      | Some x -> return x
  in
  Log.info "Kv_ro" "Reading first file";
  lwt () = 
    match_lwt kv_ro#read "rootdir/HELLOWOR.LD" with
      | Some s 
        -> (Log.info "Kv_ro" "contents:";
            Lwt_stream.iter (fun b ->
              printf "%s%!" (Bitstring.string_of_bitstring b);
            ) s
        )
      | None -> printf "File not found\n%!"; exit 1
  in
  printf "Done\n%!";
  return ()

