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
# Compile a backbone app
#
task 'build:src', 'Compile src', ->

  exec 'coffee --bare --output tst/js src ', ($err, $stdout, $stderr) ->

    util.log $err if $err?
    util.log $stderr if $stderr?
    util.log $stdout if $stdout?
    util.log 'ok' unless $stdout?

#
# Build the final app
#
task 'build:app', 'Build the app', ->

  exec 'r.js -o build.js', ($err, $stdout, $stderr) ->

    util.log $err if $err?
    util.log $stderr if $stderr?
    util.log $stdout if $stdout?
    util.log 'ok' unless $stdout?

#
# Compile the Katrac Parser
#
task 'build:kc', 'Build the parser', ->

  exec 'jison src/lib/kc.y src/lib/kc.l --outfile tst/js/lib/kc.js', ($err, $stdout, $stderr) ->

    util.log $err if $err if $err?
    util.log $stderr if $stderr if $stderr?
    util.log $stdout if $stdout if $stdout?
    util.log 'ok' unless $stdout?

