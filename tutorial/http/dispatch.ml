open Printf
open Log
open Lwt
open Regexp

let content_type_xhtml = ["content-type","text/html"]
let content_type_css = [ "content-type", "text/css" ]

(* Dynamic Dispatch *)
module Dynamic = struct

  let dyn ?(headers=[]) req body =
    printf "Dispatch: dynamic URL %s\n%!" (Http.Request.path req);
    lwt body = body in
    let status = `OK in
    Http.Server.respond ~body ~headers ~status ()

  let dyn_xhtml req xhtml =
    dyn ~headers:content_type_xhtml req (return (Cow.Html.to_string xhtml))

  (* dispatch non-file URLs *)
  let dispatch req =
    function
    | [] | [""]
    | [""; "index.html"] -> dyn_xhtml req <:html< Hello World ! >>
    | x                  -> Http.Server.respond_not_found ~url:(Http.Request.path req) ()

end

(* handle exceptions with a 500 *)
let exn_handler exn =
  let body = Printexc.to_string exn in
  error "HTTP" "ERROR: %s" body;
  return ()

let rec remove_empty_tail = function
  | [] | [""] -> []
  | hd::tl -> hd :: remove_empty_tail tl

(* Very inefficient *)
let string_of_stream s =
  Lwt_stream.to_list s >|= Bitstring.concat >|= Bitstring.string_of_bitstring

(* main callback function *)
let t static conn_id req =
  let path = Http.Request.path req in
  let path_elem =
    remove_empty_tail (Re.split_delim (Re.from_string "/") path)
  in

  (* determine if it is static or dynamic content *)
  match_lwt static#read path with
  | Some body ->
     lwt body = string_of_stream body in
     Http.Server.respond ~body ()
  | None ->
     Dynamic.dispatch req path_elem
