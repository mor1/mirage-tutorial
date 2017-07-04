open Mirage

let port =
  let doc = Key.Arg.info
      ~doc:"Listening port."
      ~docv:"PORT" ~env:"PORT" ["port"]
  in
  Key.(create "port" Arg.(opt int 80 doc))

let keys = Key.([ abstract port ])

let fs_key = Key.(value @@ kv_ro ())
let staticfs = generic_kv_ro ~key:fs_key "./static"

let httpsvr =
  let stack = generic_stackv4 default_network in
  http_server @@ conduit_direct ~tls:false stack

let packages = List.map package [
    "cow";
    "cowabloga";
    "astring";
    "magic-mime";
    "mirage-http";
    "mirage-logs";
    "uri";
  ]

let main =
  foreign ~packages ~keys "Server.Main"
    (http @-> kv_ro @-> job)

let () =
  register ~packages "tutorial" [
    main $ httpsvr $ staticfs
  ]
