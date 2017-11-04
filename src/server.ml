open Lwt.Infix

let err fmt = Fmt.kstrf failwith fmt

module Main
    (S: Cohttp_lwt.S.Server)
    (STATIC: Mirage_types_lwt.KV_RO)
= struct

  let http_src = Logs.Src.create "http" ~doc:"HTTP server"
  module Http_log = (val Logs.src_log http_src : Logs.LOG)

  let size_then_read ~pp_error ~size ~read device name =
    size device name >>= function
    | Error e -> err "%a" pp_error e
    | Ok size ->
      read device name 0L size >>= function
      | Error e -> err "%a" pp_error e
      | Ok bufs -> Lwt.return (Cstruct.copyv bufs)

  let static_read =
    size_then_read ~pp_error:STATIC.pp_error ~size:STATIC.size ~read:STATIC.read

  let respond path body =
    let mime_type = Magic_mime.lookup path in
    let headers = Cohttp.Header.init () in
    let headers = Cohttp.Header.add headers "content-type" mime_type in
    S.respond_string ~status:`OK ~body ~headers ()

  let rec dispatcher static uri =
      let path = Uri.path uri in
      Http_log.info (fun f -> f "request '%s'" path);

      match path with
      | "" | "/" -> dispatcher static (Uri.with_path uri "index.html")
      | path ->
        let tail = Astring.String.head ~rev:true path in
        match tail with
        | Some '/' ->
          dispatcher static (Uri.with_path uri (path ^ "index.html"))
        | Some _ | None ->
          Lwt.catch
            (fun () ->
               static_read static path >>= fun body -> respond path body
            )
            (fun _exn -> S.respond_not_found ())

  let start http static =
    Logs.(set_level (Some Info));

    let callback (_, conn_id) request _body =
      let uri = Cohttp.Request.uri request in
      let conn_id = Cohttp.Connection.to_string conn_id in

      Http_log.info (fun f -> f "[%s] serving %s" conn_id (Uri.to_string uri));
      dispatcher static uri
    in
    let conn_closed (_, conn_id) =
      let cid = Cohttp.Connection.to_string conn_id in
      Http_log.info (fun f -> f "[%s] closing" cid);
    in
    let port = Key_gen.port () in
    Http_log.info (fun f -> f "listening on %d/TCP" port);

    http (`TCP port) @@ S.make ~conn_closed ~callback ()

end
