let static_html = "
<html>
<h1>$title$</h1>
This is a raw web-page
</html>"

let print_page title =
  let title = <:html< $str:title$ >> in
  let html = Cow.Html.of_string ~templates:["title", title] static_html in
  Printf.printf "%s\n%!" (Cow.Html.to_string html)

let main () =
  print_page "This is it!";
  Lwt.return ()
