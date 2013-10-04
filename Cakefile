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
task 'build', 'Build the app', ->

  exec 'coffee --bare --output www/js src ', ($err, $stdout, $stderr) ->

    util.log $err if $err?
    util.log $stderr if $stderr?
    util.log $stdout if $stdout?
    util.log 'ok' unless $stdout?

#
# Compile a backbone app
#
task 'serve', 'Serve the app', ->

  exec 'sencha fs web -port 53610 start -map www', ($err, $stdout, $stderr) ->

    util.log $err if $err?
    util.log $stderr if $stderr?
    util.log $stdout if $stdout?
    util.log 'ok' unless $stdout?

#
# Compile the Katra Runtime
#
task 'build:krt', 'Build the runtime', ->

  exec 'coffee -o www/js/lib -c lib/krt.coffee', ($err, $stdout, $stderr) ->

    util.log 'error : ' + $err if $err?
    util.log 'ok' unless $err?

#
# Compile the Katrac Parser
#
task 'build:kc', 'Build the parser', ->

  exec 'jison lib/kc.y lib/kc.l --outfile www/js/lib/kc.js', ($err, $stdout, $stderr) ->

    util.log $err if $err if $err?
    util.log $stderr if $stderr if $stderr?
    util.log $stdout if $stdout if $stdout?
    util.log 'ok' unless $stdout?

