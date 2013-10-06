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
      <ul data-role="listview" data-ajax="false" data-inset="true" data-theme="a">
      <li data-role="list-divider"><%= program.name %></li>
      </ul>
      <a href="#" data-role="button" data-icon="arrow-r" data-iconpos="right" data-inline="true">Run</a>
      <div>
          <pre class="prettyprint lang-basic"><%= source %>
          </pre>
      </div>
      """


  #
  # Repl page
  #
    repl:_.template """
      <form>
      <label for="repl-input">Enter code:</label>
      <textarea cols="40" rows="8" name="repl-input" id="repl-input"></textarea>
      <hr>
      <button type="button" class="run-repl" data-role="button" data-icon="arrow-r" data-iconpos="right" data-inline="true">Run</button>
      <pre><code id="repl-output"></code></pre>
      </form>
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


