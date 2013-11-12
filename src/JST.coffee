#+--------------------------------------------------------------------+
#| JST.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2013
#+--------------------------------------------------------------------+
#|
#| This file is a part of Katra
#|
#| Katra is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
# JST Template Hash
#

define (require) ->

  _ = require("underscore")

  JST =
  #
  # Home page
  #
    home:_.template """
      <ul data-role="listview" data-ajax="false" data-inset="true" data-theme="a">
      <li data-role="list-divider">Games</li>
      <% _.each(programs, function(program) { %>
          <li>
              <a href="#prog/<%= program.id %>">
                <%= program.name %>
              </a>
          </li>
      <% }); %>
      </ul>
      """

  #
  # Program details
  #
    program:_.template """
      <div class="console"></div>
      <script>
      katra.command.cls();//  reset the console
      </script>
      """



  #
  # Repl page
  #
    repl:_.template """
      <div class="console"></div>
      <script>
      katra.command.cls();//  reset the console
      </script>
      """

  #
  # About page
  #
    about:_.template """
      <img src="images/Icon_Android96.png" /><p>
      <blockquote cite="http://darkoverlordofdata.com/katra">Katra is a basic language interpreter
          written in coffee-script and using
          <a href=http://zaach.github.io/jison/>Jison</a>.
      </p><p>Katra has one goal -
          to run StarTrek.bas games from the golden age of basic programming.</blockquote>
      </p>
      <br />
      <strong><pre>

                       ------*------
        -------------  `---  ------'
        `-------- --'    / /
             \\\\-------  --
             '-----------'
      </pre></strong>
      """


