#+--------------------------------------------------------------------+
#| AboutView.coffee
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
# AboutView
#
define [
  "jquery"
  "backbone"
  "JST"
], ($, Backbone, JST) ->

  class AboutView extends Backbone.View

    render: ->
      #$('.menu a').removeClass 'active'
      #$('.menu a[href="#"]').parent().addClass 'active'
      $("#content").html JST.about()
      @
