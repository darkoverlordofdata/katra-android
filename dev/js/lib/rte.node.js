// Generated by CoffeeScript 1.6.3
var Console, FileSystem, colors;

colors = require('colors');

module.exports = {
  Console: Console = (function() {
    Console.prototype.buffer = null;

    Console.prototype.vars = null;

    function Console($prompt) {
      var stdin,
        _this = this;
      if ($prompt == null) {
        $prompt = 'katra> ';
      }
      stdin = process.openStdin();
      process.stdout.write($prompt);
      stdin.addListener("data", function($line) {
        _this.commandHandle($line.toString());
        if (_this.mode === 0) {
          return process.stdout.write($prompt);
        } else {
          return process.stdout.write('?');
        }
      });
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
      return process.stdout.write($text.blue + '\n');
    };

    Console.prototype.print = function($text) {
      return process.stdout.write($text);
    };

    Console.prototype.println = function($text) {
      return process.stdout.write($text + '\n');
    };

    Console.prototype.clear = function() {};

    return Console;

  })(),
  FileSystem: FileSystem = (function() {
    var fs, loc, path;

    function FileSystem() {}

    fs = require('fs');

    path = require('path');

    loc = __dirname.slice(0, -3) + 'bas';

    FileSystem.prototype.readFile = function($filename, $next) {
      return fs.readFile(path.join(loc, $filename.slice(1, -1)) + '.bas', function($err, $data) {
        if ($err != null) {
          return $next($err);
        } else {
          return $next(null, String($data));
        }
      });
    };

    FileSystem.prototype.writeFile = function($filename, $data, $next) {
      return fs.writeFile(path.join(loc, $filename.slice(1, -1)) + '.bas', $data, $next);
    };

    FileSystem.prototype.deleteFile = function($filename, $next) {
      return fs.unlink(path.join(loc, $filename.slice(1, -1)) + '.bas', $next);
    };

    return FileSystem;

  })()
};
