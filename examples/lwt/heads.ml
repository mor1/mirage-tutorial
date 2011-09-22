open Lwt
open OS

let main () =
  let heads =
    Time.sleep 1.0 >>
    (* The (>>) operator is an "anonymous bind"
       t1 >> t2
       lwt () = t1 in t2
       t1 >>= fun () -> t2
     *) 
    return (Console.log "Heads");
  in
  let tails =
    Time.sleep 2.0 >>
    (* Console.log_s is an Lwt version of normal logging *)
    Console.log_s "Tails";
  in
  (* The <&> operator is an alias for Lwt.join *)
  lwt () = heads <&> tails in
  Console.log_s "Finished"

