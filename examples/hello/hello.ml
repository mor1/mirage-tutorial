open Lwt
open Printf

let main () =
  OS.Console.log "Hello Mirage World!";
  for_lwt i = 1 to 10 do
    OS.Console.log (sprintf "Nap time %d" i);
    OS.Time.sleep 1.0
  done
