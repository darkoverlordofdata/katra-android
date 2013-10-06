#+--------------------------------------------------------------------+
#| ProgramModel.coffee
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
# ProgramModel
#

define (require) ->

  $         = require("jquery")
  Backbone  = require("backbone")

  # The Model constructor
  class Program extends Backbone.Model
