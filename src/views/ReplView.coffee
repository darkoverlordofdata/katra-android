#+--------------------------------------------------------------------+
#| ReplView.coffee
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
# ReplView
#
define (require) ->

  $         = require("jquery")
  Backbone  = require("backbone")
  JST       = require("JST")

  require 'rte'   # i/o runtime
  require 'katra' # the katra runtime
  require 'kc'    # the katra compiler

  #
  # Basic Repl
  #
  class ReplView extends Backbone.View

    #
    # Render the repl paage
    #
    # @return [Void]
    #
    render: ->
      #$('.menu a').removeClass 'active'
      #$('.menu a[href="#"]').parent().addClass 'active'
      $("#content").html JST.repl()
      $('[data-role="content"]').trigger('create')
      $('.run-repl').on "click", @exec
      @


    #
    # Execute the input
    #
    # @return [Void]
    #
    exec: () ->
      for line in $('#repl-input').val().split('\n')
        try
          kc.parse line+"\n"
        catch e
          $('#repl-output').html e.toString()
          return