open Lwt
open Printf

let port = 80

let ip =
  let open Net.Nettypes in
  ( ipv4_addr_of_tuple (10l,0l,0l,2l),
    ipv4_addr_of_tuple (255l,255l,255l,0l),
   [ipv4_addr_of_tuple (10l,0l,0l,1l)]
  )

let get_file filename =
  OS.Devices.with_kv_ro "static" (fun kv_ro ->
    match_lwt kv_ro#read filename with
    |None -> return None
    |Some k -> Bitstring_stream.string_of_stream k >|= (fun x -> Some x)
  )
 
let main () =
  Log.info "Server" "listening to HTTP on port %d" port;
  let callback conn_id req =
    printf "%s\n%!" (Http.Request.path req);
    match_lwt get_file (Http.Request.path req) with
    |Some body ->
      Http.Server.respond ~body ()
    |None ->
      if Http.Request.path req = "/" then (
        let headers = ["content-type","text/html"] in
        let body = Content.body in
        Http.Server.respond ~body ~headers () 
      ) else
        Http.Server.respond_not_found ~url:(Http.Request.path req) ()
  in 
  let exn_handler exn =
    Log.info "Server" "EXN %s" (Printexc.to_string exn);
    return () in
  let spec = {
    Http.Server.address = "0.0.0.0";
    auth = `None;
    callback;
    conn_closed = (fun _ -> ());
    port;
    exn_handler = exn_handler;
    timeout = Some 300.;
  } in
  Log.info "Server" "Starting server";
  Net.Manager.create (fun mgr interface id ->
    let src = None, port in
    Net.Manager.configure interface (`IPv4 ip) >>
    Http.Server.listen mgr (`TCPv4 (src, spec))
  )

