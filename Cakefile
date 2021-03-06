#+--------------------------------------------------------------------+
#| Cakefile
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2012 - 2013
#+--------------------------------------------------------------------+
#|
#| This file is a part of Katra
#|
#| Katra is free software you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
#	cake
#

fs = require 'fs'
util = require 'util'
{exec} = require 'child_process'


#
# Compile coffee-script sources
#
task 'build:src', 'Compile src', ->

  exec 'coffee --bare --output dev/js src ', ($err, $stdout, $stderr) ->

    util.log $err if $err?
    util.log $stderr if $stderr?
    util.log $stdout if $stdout?
    util.log 'ok' unless $stdout?

#
# Generate the parser
#
task 'build:parser', 'Build the parser', ->

  exec 'jison src/lib/kc.y src/lib/kc.l --outfile dev/js/lib/kc.bnf.js', ($err, $stdout, $stderr) ->

    util.log $err if $err if $err?
    util.log $stderr if $stderr if $stderr?
    util.log $stdout if $stdout if $stdout?
    util.log 'ok' unless $stdout?

#
# Build the production application folder
#
task 'build:www', 'Build the www application', ->

  exec 'r.js -o build.js', ($err, $stdout, $stderr) ->

    util.log $err if $err?
    util.log $stderr if $stderr?
    util.log $stdout if $stdout?
    util.log 'ok' unless $stdout?

#
# Build the android platform
#
task 'build:android', 'Build the android application', ->

  exec 'cordova build android', ($err, $stdout, $stderr) ->

    util.log $err if $err?
    util.log $stderr if $stderr?
    util.log $stdout if $stdout?
    util.log 'ok' unless $stdout?


#
# Build from a context free grammar (BNF)
#
#
task 'build:bnf', 'Build the parser using BNF source', ->

  #
  # Build the AST lib
  #
  exec 'coffee -o js -c src/katra.coffee', ($err, $stdout, $stderr) ->

    util.log $err if $err if $err?
    util.log $stderr if $stderr if $stderr?
    util.log $stdout if $stdout if $stdout?
    util.log 'ok' unless $stdout?

    #
    # Build the runtime support lib
    #
    exec 'coffee -o js -c src/rte.browser.coffee', ($err, $stdout, $stderr) ->

      util.log $err if $err if $err?
      util.log $stderr if $stderr if $stderr?
      util.log $stdout if $stdout if $stdout?
      util.log 'ok' unless $stdout?

      #
      # Generate the parser
      #
      exec 'jison src/kc.y src/kc.l --outfile js/kc.bnf.js', ($err, $stdout, $stderr) ->

        util.log $err if $err if $err?
        util.log $stderr if $stderr if $stderr?
        util.log $stdout if $stdout if $stdout?
        util.log 'ok' unless $stdout?


