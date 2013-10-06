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
    jquery        : "vendor/jquery-2.0.3.min"
    jquerymobile  : "vendor/jquery.mobile-1.3.2.min"
    underscore    : "vendor/lodash.underscore.min"
    backbone      : "vendor/backbone-min"
    katra         : "lib/katra"
    kc            : "lib/kc"


  shim:
    backbone:
      deps        : ["underscore", "jquery"]
      exports     : "Backbone"


#
# Start me up
#
define (require) ->

  $           = require("jquery")
  Backbone    = require("backbone")
  Router      = require("Router")

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


