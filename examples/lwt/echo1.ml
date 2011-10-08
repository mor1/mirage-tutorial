open Lwt (* provides >>= and join *)
open OS  (* provides Time, Console and Main *)

let read_line () =
  Time.sleep (Random.float 1.5) >>
  return (String.make (Random.int 20) 'a')

let rec echo_server =
  function
  |0 -> return ()
  |num_lines ->
    lwt s = read_line () in
    Console.log s;
    echo_server (num_lines - 1)

(* Imperative version *)
let echo_server_2 num =
  for_lwt i = 1 to num do
     read_line ()  >>= Console.log_s 
  done

let main () =
  Random.self_init ();
  echo_server 10
