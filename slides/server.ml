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
    |Some s -> 
      lwt x = Lwt_stream.to_list s >|= Cstruct.copy_buffers in
      return (Some x)
  )

module CL = Cohttp_lwt_mirage
module C = Cohttp
 
let main () =
  let callback conn_id ?body req =
    printf "%s\n%!" (CL.Request.path req);
    match_lwt get_file (CL.Request.path req) with
    |Some body ->
      CL.Server.respond_string ~status:`OK ~body ()
    |None ->
      if CL.Request.path req = "/" then (
        let headers = C.Header.init_with "content-type" "text/html" in
        let body = Content.body in
        CL.Server.respond_string ~status:`OK ~body ~headers () 
      ) else
        CL.Server.respond_not_found ~uri:(CL.Request.uri req) ()
  in 
  let spec = {
    CL.Server.callback;
    conn_closed = (fun _ _ -> ());
  } in
  Net.Manager.create (fun mgr interface id ->
    let src = None, port in
    Net.Manager.configure interface (`IPv4 ip) >>
    CL.listen mgr src spec
  )

