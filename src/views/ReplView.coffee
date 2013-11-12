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

  require 'jqueryconsole'
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
      $("#content").html JST.repl()
      $('[data-role="content"]').trigger('create')
      @


