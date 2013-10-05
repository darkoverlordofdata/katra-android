#+--------------------------------------------------------------------+
#| ProgramRouter.coffee
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
# ProgramRouter
#

# Includes file dependencies
define [
  "jquery"
  "backbone"
  "views/HomeView"
  "views/ReplView"
  "views/AboutView"
  ], ($, Backbone, HomeView, ReplView, AboutView) ->

  class Router extends Backbone.Router

    homeView: null
    replView: null
    aboutView: null

    initialize: ->
      Backbone.history.start()

    routes:
      ""        : "home"
      "repl"    : "repl"
      "about"   : "about"


    home: ->
      console.log "Route [home]"
      @homeView = new HomeView unless @homeView?
      @homeView.render()

    repl: ->
      console.log "Route [repl]"
      @replView = new ReplView unless @replView?
      @replView.render()

    about: ->
      console.log "Route [about]"
      @aboutView = new AboutView unless @aboutView?
      @aboutView.render()

