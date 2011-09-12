open Lwt
open Printf

let port = 80

let main () =
  Log.info "Server" "listening to HTTP on port %d" port;
  lwt js = OS.Devices.with_kv_ro "fs" (fun kv_ro ->
    match_lwt kv_ro#read "slides.js" with
    |None -> assert false
    |Some k -> Bitstring_stream.string_of_stream k) in
  let callback conn_id req =
    printf "%s\n%!" (Http.Request.path req);
    match Http.Request.path req with
    |"/slides.js" ->
      Http.Server.respond ~body:js ~headers:["content-type","text/javascript"] ()
    |"/"|"" ->
      let headers = ["content-type","text/html"] in
      Http.Server.respond ~body:Slides.body ~headers () 
    |_ ->
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
    Http.Server.listen mgr (`TCPv4 (src, spec))
  )

