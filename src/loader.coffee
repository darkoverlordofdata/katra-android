#+--------------------------------------------------------------------+
#| loader.coffee
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
# Load the app
#

# Sets the require.js configuration for your application.
require.config
  
  # 3rd party script alias names (Easier to type "jquery" than "libs/jquery-1.8.2.min")
  paths:
    
    # Core Libraries
    jquery: "libs/jquery"
    jquerymobile: "libs/jquerymobile"
    underscore: "libs/lodash"
    backbone: "libs/backbone"

  
  # Sets the configuration for your third party scripts that are not AMD compatible
  shim:
    backbone:
      deps: ["underscore", "jquery"]
      exports: "Backbone" #attaches "Backbone" to the window object

# end Shim Configuration

# Includes File Dependencies
require ["jquery", "backbone", "routers/ProgramRouter"], ($, Backbone, Router) ->
  
  # Set up the "mobileinit" handler before requiring jQuery Mobile's module
  $(document).on "mobileinit", ->
    
    # Prevents all anchor click handling including the addition of active button state and alternate link bluring.
    $.mobile.linkBindingEnabled = false
    
    # Disabling this will prevent jQuery Mobile from handling hash changes
    $.mobile.hashListeningEnabled = false

  require ["jquerymobile"], ->
    
    # Instantiates a new Backbone.js Mobile Router
    @router = new Router()


