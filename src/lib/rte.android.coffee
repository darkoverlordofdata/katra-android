#+--------------------------------------------------------------------+
#| rte.browser.coffee
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
# Rte Concerns - browser
#
MODE_REPL       = 0     # Console REPL mode
MODE_RUN        = 1     # Console RUN mode

window.rte =

  #
  # wrapper for text area
  #
  Console: class Console

    mode: MODE_REPL
    element: ''
    trigger: ''
    console: ''
    buffer: null
    vars: null
    #

    #
    # initialize a console
    #
    # @param  [String]  element DOM root element
    # @param  [String]  prompt  string to print
    # @return none
    #
    constructor: () ->
      @element = '#repl-input'
      @console = '#repl-output'
      @trigger = '#run-repl'
      @clear()

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

    debug: ($text) =>
      $(@console).append String($text).replace(/\ /g, "&nbsp;")+"<br />"


    #
    # print to console
    #
    # @param  [String]  text  text to print
    # @return none
    #
    print: ($text) ->
      $(@console).append $text.replace(/\ /g, "&nbsp;")

    #
    # print with newline to console
    #
    # @param  [String]  text  text to print
    # @return none
    #
    println: ($text) ->
      $(@console).append $text.replace(/\ /g, "&nbsp;")+"<br />"

    #
    # create a new console, erasing the previuos
    #
    # @return none
    #
    clear: ->
      $(@element).val ''
      $(@console).text ''




  FileSystem: class FileSystem

    $loc = '/bas/'

    readFile: ($filename, $next) ->
      $.get $loc+$filename[1...-1]+'.bas', ($data) ->
        $next null, $data


    writeFile: ($filename, $data, $next) ->

    deleteFile: ($filename, $next) ->
