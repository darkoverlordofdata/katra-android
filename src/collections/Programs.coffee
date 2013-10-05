#+--------------------------------------------------------------------+
#| Programs.coffee
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
# Programs
#

# Includes file dependencies
define [
  "jquery"
  "backbone"
  "models/Program"
  ], ($, Backbone, Program) ->


  class Programs extends Backbone.Collection

    model: Program

    constructor: ->
      super [
        {"id":1, "name":"Test Program", "source":"TEST.BAS"}
        {"id":2, "name":"STAR TREK: BY MIKE MAYFIELD", "source":"STTR1.bas"}
        {"id":3, "name":"Romulan High Command", "source":"romulan.bas"}
        {"id":4, "name":"Another Start Trek", "source":"strtrk.bas"}
        {"id":5, "name":"HI!  I'M ELIZA.  WHAT'S YOUR PROBLEM?", "source":"eliza.bas"}
      ]



