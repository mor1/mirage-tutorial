let mk_css color1 color2 = <:css<
$Cow.Css.reset_padding$;
.c1 {
  color: $color1$;
  .c2 {
    color: $color2$;
  }
}
>>

let main () =
  let css = mk_css <:css< #fefefe >> <:css< #ababab >> in
  Printf.printf "%s\n%!" (Cow.Css.to_string css);
  Lwt.return ()
  
