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

define [
  "jquery"
  "backbone"
  "collections/Programs"
  "JST"
  ], ($, Backbone, Programs, JST) ->

  class HomeView extends Backbone.View



    render: ->
      #$('.menu a').removeClass 'active'
      #$('.menu a[href="#"]').parent().addClass 'active'

      @programs = new Programs
      $("#content").html JST.home()
      @
