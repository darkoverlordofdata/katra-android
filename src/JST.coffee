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

define [
  "underscore"
], (_) ->

  JST =
    home:_.template """
      <h2>Select a Category Below:</h2>
      <ul data-role="listview" data-inset="true">
      <li><a href="#category?animals" class="animals">Animals</a></li>
      <li><a href="#category?colors" class="colors">Colors</a></li>
      <li><a href="#category?vehicles" class="vehicles">Vehicles</a></li>
      </ul>
      """


    list:_.template('')

    program:_.template('')


    repl:_.template """
      <form>
      <label for="repl-input">Enter code:</label>
      <textarea cols="40" rows="8" name="repl-input" id="repl-input"></textarea>
      <hr>
      <pre><code id="repl-output"></code></pre>
      </form>
      """


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


