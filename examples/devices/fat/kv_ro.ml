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
    match_lwt kv_ro#read "HELLOWOR.LD" with
      | Some s 
        -> (Log.info "Kv_ro" "contents:";
            Lwt_stream.iter (fun b ->
              printf "%s%!" (Bitstring.string_of_bitstring b);
            ) s
        )
      | None -> printf "File not found\n%!"; exit 1
  in
  
  Log.info "Kv_ro" "Reading second file";
  lwt () = 
    match_lwt kv_ro#read "SECOND.TXT" with
      | Some s 
        -> (lwt buf = Bitstring_stream.string_of_stream s in
            let len = String.length buf in
            printf "File size=%d\n%!" len;
            printf "Last 5 chars: %s\n%!" (String.sub buf (len-6) 5);
            return ()
        )
      | None -> printf "File not found\n%!"; exit 1
  in
  
  Log.info "Kv_ro" "Reading directory";
  kv_ro#iter_s (fun file ->
    Log.info "Kv_ro" "filename '%s' contents:" file;
    match_lwt kv_ro#read file with
      | Some s 
        -> (Lwt_stream.iter
              (fun bits -> 
                printf "%s%!" (Bitstring.string_of_bitstring bits)) 
              s)
  )
