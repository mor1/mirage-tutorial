let mk_page title = <:html<
<h1>$str:title$</h1>

This is a web-page, where the title is a string parameter

>>

let main () =
  let page = mk_page "Every page needs a good title!" in
  Printf.printf "%s\n%!" (Cow.Html.to_string page);
  Lwt.return ()
