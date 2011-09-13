open Cow
open Printf

type layout =
 |Regular
 |Faux_widescreen
 |Widescreen

let layout_to_string = function
 |Regular -> "layout-regular"
 |Faux_widescreen -> "layout-faux-widescreen"
 |Widescreen -> "layout-widescreen"

type presentation = {
  layout: layout;
}

let presentation = {
  layout = Regular;
}

let slides p =
  let template = "template-default" in
  let classes = sprintf "slides %s %s" (layout_to_string p.layout) template in
<:html<
<html>
  <head>
    <title>Mirage Tutorial</title>
    <script type="text/javascript" src="slides.js">&nbsp; </script>
  </head>
  
  <style>
  </style>

  <body>

    <section class="$str:classes$">
      
      <article class='biglogo'>
      </article>

      <article>
        <h1>
          Title Goes Here Up
          <br />
          To Two Lines
        </h1>
        <p>
          Sergey Brin
          <br />
          May 10, 2011
        </p>
      </article>
      
      <article>
        <p>
          This is a slide with just text. This is a slide with just text.
          This is a slide with just text. This is a slide with just text.
          This is a slide with just text. This is a slide with just text.
        </p>
        <p>
          There is more text just underneath.
        </p>
      </article>

      <article>
        <h3>
          Simple slide with header and text
        </h3>
        <p>
          This is a slide with just text. This is a slide with just text.
          This is a slide with just text. This is a slide with just text.
          This is a slide with just text. This is a slide with just text.
        </p>
        <p>
          There is more text just underneath with a <code>code sample: 5px</code>.
        </p>
      </article>

      <article class='smaller'>
        <h3>
          Simple slide with header and text (small font)
        </h3>
        <p>
          This is a slide with just text. This is a slide with just text.
          This is a slide with just text. This is a slide with just text.
          This is a slide with just text. This is a slide with just text.
        </p>
        <p>
          There is more text just underneath with a <code>code sample: 5px</code>.
        </p>
      </article>

      <article>
        <h3>
          Slide with bullet points and a longer title, just because we
          can make it longer
        </h3>
        <ul>
          <li>
            Use this template to create your presentation
          </li>
          <li>
            Use the provided color palette, box and arrow graphics, and
            chart styles
          </li>
          <li>
            Instructions are provided to assist you in using this
            presentation template effectively
          </li>
          <li>
            At all times strive to maintain Google's corporate look and feel
          </li>
        </ul>
      </article>

      <article>
        <h3>
          Slide with bullet points that builds
        </h3>
        <ul class="build">
          <li>
            This is an example of a list
          </li>
          <li>
            The list items fade in
          </li>
          <li>
            Last one!
          </li>
        </ul>

        <div class="build">
          <p>Any element with child nodes can build.</p>
          <p>It doesn't have to be a list.</p>
        </div>
      </article>

      <article class='smaller'>
        <h3>
          Slide with bullet points (small font)
        </h3>
        <ul>
          <li>
            Use this template to create your presentation
          </li>
          <li>
            Use the provided color palette, box and arrow graphics, and
            chart styles
          </li>
          <li>
            Instructions are provided to assist you in using this
            presentation template effectively
          </li>
          <li>
            At all times strive to maintain Googles corporate look and feel
          </li>
        </ul>
      </article>

      <article>
        <h3>
          Slide with a table
        </h3>
        
        <table>
          <tr>
            <th> Name </th>
            <th> Occupation </th>
          </tr>
          <tr>
            <td> Luke Mahé </td>
            <td> V.P. of Keepin’ It Real </td>
          </tr>
          <tr>
            <td> Marcin Wichary </td>
            <td> The Michael Bay of Doodles </td>
          </tr>
        </table>
      </article>
      
      <article class='smaller'>
        <h3>
          Slide with a table (smaller text)
        </h3>
        
        <table>
          <tr>
            <th> Name </th>
            <th> Occupation </th>
          </tr>
          <tr>
            <td> Luke Mahé </td>
            <td> V.P. of Keepin’ It Real </td>
          </tr>
          <tr>
            <td> Marcin Wichary </td>
            <td> The Michael Bay of Doodles </td>
          </tr>
        </table>
      </article>
      
      <article>
        <h3>
          Styles
        </h3>
        <ul>
          <li> <span class='red'>class="red"</span> </li>
          <li> <span class='blue'>class="blue"</span> </li>
          <li> <span class='green'>class="green"</span> </li>
          <li> <span class='yellow'>class="yellow"</span> </li>
          <li> <span class='black'>class="black"</span> </li>
          <li> <span class='white'>class="white"</span> </li>
          <li> <b>bold</b> and <i>italic</i> </li>
        </ul>
      </article>
      
      <article>
        <h2>
          Segue slide
        </h2>
      </article>

      <article>
        <h3>
          Slide with an image
        </h3>
        <p>
          <img style='height: 500px' src='images/example-graph.png' />
        </p>
        <div class='source'>
          Source: Sergey Brin
        </div>
      </article>

      <article>
        <h3>
          Slide with an image (centered)
        </h3>
        <p>
          <img class='centered' style='height: 500px' src='images/example-graph.png' />
        </p>
        <div class='source'>
          Source: Larry Page
        </div>
      </article>

      <article class='fill'>
        <h3>
          Image filling the slide (with optional header)
        </h3>
        <p>
          <img src='images/example-cat.jpg' />
        </p>
        <div class='source white'>
          Source: Eric Schmidt
        </div>
      </article>

      <article>
        <h3>
          This slide has some code
        </h3>
        <section>
        <pre>
&lt;script type='text/javascript'&gt;
  // Say hello world until the user starts questioning
  // the meaningfulness of their existence.
  function helloWorld(world) {
    for (var i = 42; --i &gt;= 0;) {
      alert('Hello ' + String(world));
    }
  }
&lt;/script&gt;
&lt;style&gt;
  p { color: pink }
  b { color: blue }
  u { color: 'umber' }
&lt;/style&gt;
</pre>
        </section>
      </article>
      
      <article class='smaller'>
        <h3>
          This slide has some code (small font)
        </h3>
        <section>
        <pre>
&lt;script type='text/javascript'&gt;
  // Say hello world until the user starts questioning
  // the meaningfulness of their existence.
  function helloWorld(world) {
    for (var i = 42; --i &gt;= 0;) {
      alert('Hello ' + String(world));
    }
  }
&lt;/script&gt;
&lt;style&gt;
  p { color: pink }
  b { color: blue }
  u { color: 'umber' }
&lt;/style&gt;
</pre>
        </section>
      </article>
      
      <article>
        <q>
          The best way to predict the future is to invent it.
        </q>
        <div class='author'>
          Alan Kay
        </div>
      </article>
      
      <article class='smaller'>
        <q>
          A distributed system is one in which the failure of a computer 
          you didn’t even know existed can render your own computer unusable.
        </q>
        <div class='author'>
          Leslie Lamport
        </div>
      </article>
      
      <article class='nobackground'>
        <h3>
          A slide with an embed + title
        </h3>
        
        <iframe src='http://www.google.com/doodle4google/history.html'></iframe>
      </article>

      <article class='nobackground'>
        <iframe src='http://www.google.com/doodle4google/history.html'></iframe>
      </article>

      <article class='fill'>
        <h3>
          Full-slide embed with (optional) slide title on top
        </h3>
        <iframe src='http://www.google.com/doodle4google/history.html'></iframe>
      </article>
      
      <article>
        <h3>
          Thank you!
        </h3>
        
        <ul>
          <li>
            <a href='http://www.google.com'>google.com</a>
          </li>
        </ul>
      </article>

    </section>

  </body>
</html>
>>
let body = Xml.to_string (slides presentation)
