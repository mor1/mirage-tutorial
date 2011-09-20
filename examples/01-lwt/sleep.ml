let main () =
  lwt () = OS.Time.sleep 1.0 in
  lwt () = OS.Time.sleep 2.0 in
  OS.Console.log "Wake up sleep.ml!\n";
  Lwt.return ()

