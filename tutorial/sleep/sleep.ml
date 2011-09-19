open Lwt
open Printf

let main () =
  printf "Hello Mirage World!\n%!";
  for_lwt i = 1 to 10 do
    printf "Nap time %d\n%!" i;
    OS.Time.sleep 1.0
  done
