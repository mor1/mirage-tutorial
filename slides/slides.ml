open Cow
open Printf

(** Layout modes for the rendering of the slides *)
type layout =
 |Regular
 |Faux_widescreen
 |Widescreen

(* Styles of each slide *)
type style =
 |Title
 |Smaller
 |No_background
 |Fill

(* A single slide *)
type article = {
  styles: style list;
  content: Xml.t;
}

type presentation = {
  topic: string;
  layout: layout;
  articles: article list;
}

let layout_to_string = function
 |Regular -> "layout-regular"
 |Faux_widescreen -> "layout-faux-widescreen"
 |Widescreen -> "layout-widescreen"

let style_to_string = function
 |Title -> "biglogo"
 |Smaller -> "smaller"
 |No_background -> "nobackground"
 |Fill -> "fill"

(** Render one slide 
  * @param styles How to render the slide (title, normal, or smaller font)
  * @param title Main title string of slide
  * @param subtitle Optional subtitle for slide 
  * @param content XHTML body of the slide
 **)
let article_to_xhtml article =
 let attrs = match article.styles with
   |[] -> []
   |xs -> ["class", (String.concat " " (List.map style_to_string xs))]
 in
 <:html<
   <article $alist:attrs$>
     $article.content$
   </article>
 >>

(** Generate slides XHTML, given an input presentation *)
let slides p =
  let template = "template-default" in
  let classes = sprintf "slides %s %s" (layout_to_string p.layout) template in
<:html<
<html>
  <head>
    <title>$str:p.topic$</title>
    <script type="text/javascript" src="slides.js">&nbsp; </script>
  </head>
  
  <style>
  </style>

  <body>
    <section class="$str:classes$">
      $list:List.map article_to_xhtml p.articles$
    </section>
  </body>
</html>
>>
