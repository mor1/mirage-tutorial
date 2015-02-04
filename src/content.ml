open Lwt

let body =
  let preamble = "\
<!DOCTYPE html>
  <!--[if IE 8]><html class=\"no-js lt-ie9\" lang=\"en\" ><![endif]-->
  <!--[if gt IE 8]><!--><html class=\"no-js\" lang=\"en\" ><!--<![endif]-->"
  in
  let page =
  <:html<
    <head>
      <meta charset="utf-8" />
      <title>The Mirage Tutorial</title>
      <meta name="description" content="Mirage Tutorial" />
      <meta name="author" content="The Mirage Team" />

      <meta name="apple-mobile-web-app-capable" content="yes" />
      <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />

      <meta name="viewport"
            content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
      <base href="/content/" />

      <link rel="stylesheet" href="/css/site.css" media="all"> </link>

      <link rel="stylesheet" href="/css/highlight.js/solarized_light.css"> </link>

      <link rel="stylesheet" href="/reveal.js-2.6.2/css/reveal.min.css"> </link>
      <link rel="stylesheet" href="/reveal.js-2.6.2/lib/css/zenburn.css"> </link>
      <link rel="stylesheet" href="/reveal.js-2.6.2/css/theme/horizon.css" id="theme"
            media="all"> </link>

      <!--[if lt IE 9]>
          <script src="/reveal.js-2.6.2/lib/js/html5shiv.js"> </script>
      <![endif]-->

  </head>

    <body>
      <div class="reveal">
        <div class="slides">
          <section data-markdown="content.md"
                   data-separator="^\n\n----\n"
                   data-vertical="^\n\n"
                   data-notes="^Note:"
                   data-charset="iso-8859-15">
          </section>

          <div id="footer">
            <a id="index" href="/"> <img src="/img/home.png" /> </a>
            <a id="print-pdf" href="/?print-pdf">
              <img src="/img/print.png" />
            </a>
          </div>

        </div>
      </div>

      <script src="/js/vendor/jquery-2.0.3.min.js"> </script>
      <script src="/reveal.js-2.6.2/lib/js/head.min.js"> </script>
      <script src="/reveal.js-2.6.2/js/reveal.min.js"> </script>
      <script src="/reveal.js-2.6.2/js/init.js"> </script>
    </body>
  >>
  in
  preamble ^ (Cow.Html.to_string page) ^ "</html>"
