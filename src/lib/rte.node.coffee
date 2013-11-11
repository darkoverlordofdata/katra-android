#+--------------------------------------------------------------------+
#| rte.node.coffee
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
# Rte Concerns - node.js
#
colors = require('colors')


module.exports =

  Console: class Console

    buffer: null
    vars: null


    constructor: ($prompt = 'katra> ') ->

      stdin = process.openStdin()
      process.stdout.write $prompt
      stdin.addListener "data", ($line) =>
        @commandHandle $line.toString()
        if @mode is 0
          process.stdout.write $prompt
        else
          process.stdout.write '?'

    #
    # input from console
    #
    # @param  [String]  prompt  text to print
    # @param  [Array] vars  list of variables to input
    # @return true to trigger wait for io
    #
    input: ($prompt, $vars) ->
      @print $prompt if $prompt?
      @buffer = []
      @vars = $vars
      true

    debug: ($text) ->
      process.stdout.write $text.blue+'\n'

    #
    # print to console
    #
    # @param  [String]  text  text to print
    # @return none
    #
    print: ($text) ->
      process.stdout.write $text

    #
    # print with newline to console
    #
    # @param  [String]  text  text to print
    # @return none
    #
    println: ($text) ->
      process.stdout.write $text+'\n'

    #
    # create a new console, erasing the previuos
    #
    # @return none
    #
    clear: ->




  FileSystem: class FileSystem

    fs = require('fs')
    path = require('path')
    loc = __dirname[0...-3]+'bas'

    readFile: ($filename, $next) ->
      fs.readFile path.join(loc,$filename[1...-1])+'.bas', ($err, $data) ->
        if $err? then $next $err
        else $next null, String($data)

    writeFile: ($filename, $data, $next) ->
      fs.writeFile path.join(loc,$filename[1...-1])+'.bas', $data, $next

    deleteFile: ($filename, $next) ->
      fs.unlink path.join(loc,$filename[1...-1])+'.bas', $next