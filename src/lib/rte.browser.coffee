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
  # wrapper for jquery.console
  #
  Console: class Console

    mode: MODE_REPL
    element: ''
    console: null
    buffer: null
    vars: null
    #
    # jquery.console config:
    #
    animateScroll: true
    autofocus: true
    promptLabel: ''
    promptHistory: true
    welcomeMessage: 'type RUN to start'

    #
    # initialize a console
    #
    # @param  [String]  element DOM root element
    # @param  [String]  prompt  string to print
    # @return none
    #
    constructor: (@element = '.console', $prompt = '> ') ->

      @promptLabel = $prompt
      @clear()

    #
    # callback to validate the input
    #
    # @param  [String]  line  the line that was entered
    # @return true if input is valid
    #
    commandValidate: ($line) =>
      if $line is "" then false else true

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
      @console.inner.append String($text).replace(/\ /g, "&nbsp;")+"<br />"
#      @console.inner.append """
#      <div class="alert alert-info">
#      <pre class="text-info">#{$text}\n</pre>
#      </div>
#      """


    #
    # print to console
    #
    # @param  [String]  text  text to print
    # @return none
    #
    print: ($text) ->
      @console.inner.append $text.replace(/\ /g, "&nbsp;")

    #
    # print with newline to console
    #
    # @param  [String]  text  text to print
    # @return none
    #
    println: ($text) ->
      @console.inner.append $text.replace(/\ /g, "&nbsp;")+"<br />"

    #
    # create a new console, erasing the previuos
    #
    # @return none
    #
    clear: ->
      $(@element).html ''
      @console = $(@element).console(@)




  FileSystem: class FileSystem

    $loc = '/katrac/bas/'

    readFile: ($filename, $next) ->
      $.get $loc+$filename[1...-1]+'.bas', ($data) ->
        $next null, $data


    writeFile: ($filename, $data, $next) ->

    deleteFile: ($filename, $next) ->
