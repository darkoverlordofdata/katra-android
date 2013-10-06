// Generated by CoffeeScript 1.6.3
define(function(require) {
  var JST, _;
  _ = require("underscore");
  return JST = {
    home: _.template("<ul data-role=\"listview\" data-ajax=\"false\" data-inset=\"true\" data-theme=\"a\">\n<li data-role=\"list-divider\">Games</li>\n<% _.each(programs, function(program) { %>\n    <li>\n        <a href=\"#prog/<%= program.id %>\">\n          <%= program.name %>\n        </a>\n    </li>\n<% }); %>\n</ul>"),
    program: _.template("<ul data-role=\"listview\" data-ajax=\"false\" data-inset=\"true\" data-theme=\"a\">\n<li data-role=\"list-divider\"><%= program.name %></li>\n</ul>\n<a href=\"#\" data-role=\"button\" data-icon=\"arrow-r\" data-iconpos=\"right\" data-inline=\"true\">Run</a>\n<div>\n    <pre class=\"prettyprint lang-basic\"><%= source %>\n    </pre>\n</div>"),
    repl: _.template("<form>\n<label for=\"repl-input\">Enter code:</label>\n<textarea cols=\"40\" rows=\"8\" name=\"repl-input\" id=\"repl-input\"></textarea>\n<hr>\n<button type=\"button\" class=\"run-repl\" data-role=\"button\" data-icon=\"arrow-r\" data-iconpos=\"right\" data-inline=\"true\">Run</button>\n<pre><code id=\"repl-output\"></code></pre>\n</form>"),
    about: _.template("<img src=\"images/Icon_Android96.png\" /><p>\n<blockquote cite=\"http://darkoverlordofdata.com/katra\">Katra is a basic language interpreter\n    written in coffee-script and using\n    <a href=http://zaach.github.io/jison/>Jison</a>.\n</p><p>Katra has one goal -\n    to run StarTrek.bas games from the golden age of basic programming.</blockquote>\n</p>\n<br />\n<strong><pre>\n\n                 ------*------\n  -------------  `---  ------'\n  `-------- --'    / /\n       \\\\-------  --\n       '-----------'\n</pre></strong>")
  };
});
