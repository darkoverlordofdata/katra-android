// Generated by CoffeeScript 1.6.3
var Console, FileSystem, MODE_REPL, MODE_RUN,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

MODE_REPL = 0;

MODE_RUN = 1;

window.rte = {
  Console: Console = (function() {
    Console.prototype.mode = MODE_REPL;

    Console.prototype.element = '';

    Console.prototype.trigger = '';

    Console.prototype.console = '';

    Console.prototype.buffer = null;

    Console.prototype.vars = null;

    function Console() {
      this.debug = __bind(this.debug, this);
      this.element = '#repl-input';
      this.console = '#repl-output';
      this.trigger = '#run-repl';
      this.clear();
    }

    Console.prototype.input = function($prompt, $vars) {
      if ($prompt != null) {
        this.print($prompt);
      }
      this.buffer = [];
      this.vars = $vars;
      return true;
    };

    Console.prototype.debug = function($text) {
      return $(this.console).append(String($text).replace(/\ /g, "&nbsp;") + "<br />");
    };

    Console.prototype.print = function($text) {
      return $(this.console).append($text.replace(/\ /g, "&nbsp;"));
    };

    Console.prototype.println = function($text) {
      return $(this.console).append($text.replace(/\ /g, "&nbsp;") + "<br />");
    };

    Console.prototype.clear = function() {
      $(this.element).val('');
      return $(this.console).text('');
    };

    return Console;

  })(),
  FileSystem: FileSystem = (function() {
    var $loc;

    function FileSystem() {}

    $loc = '/bas/';

    FileSystem.prototype.readFile = function($filename, $next) {
      return $.get($loc + $filename.slice(1, -1) + '.bas', function($data) {
        return $next(null, $data);
      });
    };

    FileSystem.prototype.writeFile = function($filename, $data, $next) {};

    FileSystem.prototype.deleteFile = function($filename, $next) {};

    return FileSystem;

  })()
};
