#+--------------------------------------------------------------------+
#| index.coffee
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
# Katra front end controller
#

#
# Set the require configuration
#
require.config

  paths:
    jquery        : "vendor/jquery"
    jquerymobile  : "vendor/jquerymobile"
    underscore    : "vendor/lodash"
    backbone      : "vendor/backbone"
    text          : "vendor/text"
    katra         : "lib/kc"


  shim:
    backbone:
      deps        : ["underscore", "jquery"]
      exports     : "Backbone"


#
# Start me up
#
require [
  "jquery"
  "backbone"
  "Router"
  ], ($, Backbone, Router) ->

  #
  # Hook the jQueryMobile init event
  #
  $(document).on "mobileinit", ->

    #
    # turn off jQueryMobile routing so we can use Backbone
    #
    $.mobile.linkBindingEnabled = false
    $.mobile.hashListeningEnabled = false

  #
  # Start me up
  #
  require ["jquerymobile"], ->
    @router = new Router()


