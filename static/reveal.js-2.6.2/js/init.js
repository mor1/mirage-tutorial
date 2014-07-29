Reveal.initialize({
    center: false,
    history: true,
    slideNumber: true,
    rollingLinks: true,

    theme: Reveal.getQueryHash().theme,
    transition: Reveal.getQueryHash().transition || "fade",

    dependencies: [
        // cross-browser classlist shim
        { src: "/reveal.js-2.6.2/lib/js/classList.js",
          condition: function()
          {
              return !document.body.classList;
          }
        },

        // markdown slide support
        { src: "/reveal.js-2.6.2/plugin/markdown/marked.js",
          condition: function()
          {
              return !!document.querySelector( "[data-markdown]" );
          }
        },
        { src: "/reveal.js-2.6.2/plugin/markdown/markdown.js",
          condition: function()
          {
              return !!document.querySelector( "[data-markdown]" );
          }
        },

        // syntax highlight <code> elements
        { src: "/reveal.js-2.6.2/plugin/highlight/highlight.js", async: true,
          callback: function() {
              hljs.initHighlightingOnLoad();
              $('pre.no-highlight>code').removeClass().addClass("no-highlight");
          }
        },
    ]
});

Reveal.addEventListener("ready", function () {
    if(window.location.search.match(/print-pdf/gi)) {
        $('#theme').before(
            '<link rel="stylesheet"'
                + 'href="/reveal.js-2.6.2/css/print/pdf.css"> </link>'
        );
        $('#footer').remove();
    }
    $('.slide-number').each(function (i, e) {
        // no need to number title slide
        $(this).html($(this).html().replace(/^0$/g, ''));
    });
});

$(window).on('hashchange', function() {
    $('.slide-number').each(function (i, e) {
        $(this).html($(this).html()
                     .replace(/-/g, '&mdash;') // better separator
                     .replace(/^0$/g, '') // no need to number title slide
                    );
    });
});
