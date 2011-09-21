open Lwt 
open Printf

let ipaddr = Net.Nettypes.ipv4_addr_of_tuple (0l,0l,0l,0l)
(* let ipaddr = Net.Nettypes.ipv4_addr_of_tuple (10l,0l,0l,2l) *)
let port = 53

let main () =
  Log.info "Server" "finding static kv_ro block device";
  lwt static = 
    match_lwt OS.Devices.find_kv_ro "static" with
      | None   -> printf "static kv_ro not found\n%!"; exit 1
      | Some x -> return x
  in
  Log.info "Server" "found static kv_ro; reading...";
  lwt zonebuf = 
    match_lwt static#read "zonebuf" with
      | None   -> printf "File not found\n%!"; exit 1
      | Some s -> Bitstring_stream.string_of_stream s
  in
  Log.info "Server" "done";

  Log.info "Server" "starting server, port %d" port;
  Net.Manager.create (fun mgr interface id ->
    let src = (Some ipaddr, port) in
    let ip = Net.Nettypes.(
      (ipaddr,
       ipv4_addr_of_tuple (255l,255l,255l,0l),
       [ ipv4_addr_of_tuple (10l,0l,0l,1l) ]
      ))
    in
    Net.Manager.configure interface (`IPv4 ip)
    >> Dns.Server.listen zonebuf mgr src
  )
