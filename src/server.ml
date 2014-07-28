open Lwt
open V1_LWT

module Main
         (C: CONSOLE) (STATIC: KV_RO) (S: Cohttp_lwt.Server) = struct

  let start c static http =
    let read_static name =
      STATIC.size static name >>= function
      | `Error (STATIC.Unknown_key _) ->
        fail (Failure ("read_static_size " ^ name))
      | `Ok size ->
        STATIC.read static name 0 (Int64.to_int size) >>= function
        | `Error (STATIC.Unknown_key _) ->
          fail (Failure ("read_static " ^ name))
        | `Ok bufs -> return (Cstruct.copyv bufs)
    in

    let c_log s = C.log_s c s in

    let callback conn_id req body =
      let respond_ok body = S.respond_string ~status:`OK ~body () in
      let dispatch ~c_log ~read_static ~conn_id ~req =
        let path = req |> S.Request.uri |> Uri.path in
        let cpts = path
                   |> Re_str.(split_delim (regexp_string "/"))
                   |> List.filter (fun e -> e <> "")
        in
        c_log (Printf.sprintf "URL: '%s'" path)

        >>= fun () ->
        try_lwt
          read_static path >>= fun body ->
          S.respond_string ~status:`OK ~body ()
        with
        | Failure m ->
          Printf.printf "CATCH: '%s'\n%!" m;
          match cpts with
          | [] | [""] -> Content.body |> respond_ok
          | x -> S.respond_not_found ~uri:(S.Request.uri req) ()
      in
      dispatch ~c_log ~read_static ~conn_id ~req
    in
    let conn_closed conn_id () =
      (* XXX shouldn't i be able to use the Console logging here?
            C.log_s c (sp "conn %s closed\n%!" (Cohttp.Connection.to_string conn_id))
      *)
      Printf.printf "conn %s closed\n%!" (Cohttp.Connection.to_string conn_id)
    in

    let spec = {
      S.callback;
      conn_closed;
    } in
    http spec
end
