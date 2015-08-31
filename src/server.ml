open Lwt
open V1_LWT

module Main (C: CONSOLE) (STATIC: KV_RO) (S: Cohttp_lwt.Server) = struct

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

    let callback conn_id req body =
      let path = req |> Cohttp.Request.uri |> Uri.path in
      C.log c (Printf.sprintf "URL: '%s'" path);

      try_lwt
        read_static path >>= fun body ->
        S.respond_string ~status:`OK ~body ()
      with
      | Failure m ->
        Printf.printf "CATCH: '%s'\n%!" m;
        let cpts = path
                   |> Re_str.(split_delim (regexp_string "/"))
                   |> List.filter (fun e -> e <> "")
        in
        match cpts with
        | [] | [""] -> S.respond_string ~status:`OK ~body:Content.body ()
        | x -> S.respond_not_found ~uri:(Cohttp.Request.uri req) ()
    in

    let conn_closed (_, conn_id) =
      let cid = Cohttp.Connection.to_string conn_id in
      C.log c (Printf.sprintf "conn %s closed" cid)
    in

    let spec = S.make ~callback ~conn_closed () in
    http (`TCP 80) spec

end
