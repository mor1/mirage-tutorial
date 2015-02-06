open Mirage

let ipaddr =
  let address = Ipaddr.V4.of_string_exn "46.43.42.142" in
  let netmask = Ipaddr.V4.of_string_exn "255.255.255.128" in
  let gateways = [Ipaddr.V4.of_string_exn "46.43.42.129" ] in
  { address; netmask; gateways }

let staticfs =
  let mode =
    try match String.lowercase (Unix.getenv "FS") with
      | "fat" -> `Fat
      | _     -> `Crunch
    with Not_found -> `Crunch
  in
  let fat_ro dir =
    kv_ro_of_fs (fat_of_files ~dir ())
  in
  match mode, get_mode () with
  | `Fat,    _    -> fat_ro "../static"
  | `Crunch, `Xen -> crunch "../static"
  | `Crunch, _    -> direct_kv_ro "../static"

let https =
  let net =
    try match Sys.getenv "NET" with
      | "direct" -> `Direct
      | "socket" -> `Socket
      | _        -> `Direct
    with Not_found -> `Direct
  in
  let dhcp =
    try match Sys.getenv "DHCP" with
      | "" -> false
      | _  -> true
    with Not_found -> false
  in
  let stack console =
    match net, dhcp with
    | `Direct, true  -> direct_stackv4_with_dhcp console tap0
    | `Direct, false -> direct_stackv4_with_static_ipv4 console tap0 ipaddr
    | `Socket, _     -> socket_stackv4 console [Ipaddr.V4.any]
  in
  let port =
    try match Sys.getenv "PORT" with
      | "" -> 80
      | s  -> int_of_string s
    with Not_found -> 80
  in
  let server = conduit_direct (stack default_console) in
  let mode = `TCP (`Port port) in
  http_server mode server

let main =
  let libraries = [ "cow.syntax"; "cowabloga" ] in
  let packages = [ "cow";"cowabloga" ] in
  foreign ~libraries ~packages "Server.Main"
    (console @-> kv_ro @-> http @-> job)

let () =
  register "tutorial" [
    main $ default_console $ staticfs $ https
  ]
