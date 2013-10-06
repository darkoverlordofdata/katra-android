#+--------------------------------------------------------------------+
#| HomeView.coffee
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
# HomeView
#
define (require) ->

  $         = require("jquery")
  Backbone  = require("backbone")
  Programs  = require("collections/Programs")
  JST       = require("JST")

  #
  # The main page
  #
  class HomeView extends Backbone.View

    #
    # Render the main paage
    #
    # @return [Void]
    #
    render: ->
      #$('.menu a').removeClass 'active'
      #$('.menu a[href="#"]').parent().addClass 'active'

      @programs = new Programs
      $("#content").html JST.home(programs: @programs.toJSON())
      $('[data-role="content"]').trigger('create');
      @
