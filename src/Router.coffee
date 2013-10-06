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
# Router
#
define (require) ->

  $             = require("jquery")
  Backbone      = require("backbone")
  HomeView      = require("views/HomeView")
  ReplView      = require("views/ReplView")
  AboutView     = require("views/AboutView")
  ProgramView   = require("views/ProgramView")


  #
  #   Top level application controller for katra
  #
  class Router extends Backbone.Router

    #
    # @property [Object] homeView render the main page
    #
    homeView: null
    #
    # @property [Object] replView render the repl page
    #
    replView: null
    #
    # @property [Object] aboutView render the about info
    #
    aboutView: null
    #
    # @property [Object] progView render the program details
    #
    progView: null

    #
    # @property [Object<Array>] routes  hash of valid routes/actions
    #
    routes:
      ""          : "homeAction"
      "repl"      : "replAction"
      "about"     : "aboutAction"
      "prog/:id"  : "progAction"

    #
    # Initialize
    #
    #   Initialize routing
    #
    # @return [Void]
    #
    initialize: ->
      Backbone.history.start()


    #
    # Home
    #
    # The main page
    #
    # @access	public
    # @return [Void]
    #
    homeAction: ->
      @homeView = new HomeView unless @homeView?
      @homeView.render()

    #
    # Repl
    #
    # A Basic repl
    #
    # @access	public
    # @return [Void]
    #
    replAction: ->
      @replView = new ReplView unless @replView?
      @replView.render()

    #
    # About
    #
    # About Katra
    #
    # @access	public
    # @return [Void]
    #
    aboutAction: ->
      @aboutView = new AboutView unless @aboutView?
      @aboutView.render()


    #
    # Program details
    #
    # Run?
    #
    # @access	public
    # @param  [Integer] id  record id
    # @return [Void]
    #
    progAction: (id) ->
      @progView = new ProgramView(id)
      @progView.render()
