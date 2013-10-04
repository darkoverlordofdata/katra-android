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
define ["jquery", "backbone", "../models/ProgramModel", "../collections/ProgramsCollection", "../views/ProgramView"], ($, Backbone, ProgramModel, ProgramsCollection, ProgramView) ->

  # Extends Backbone.Router
  class ProgramRouter extends Backbone.Router

    # The Router constructor
    initialize: ->

      # Instantiates a new Animal Category View
      @animalsView = new ProgramView(
        el: "#animals"
        collection: new ProgramsCollection([],
          type: "animals"
        )
      )

      # Instantiates a new Colors Category View
      @colorsView = new ProgramView(
        el: "#colors"
        collection: new ProgramsCollection([],
          type: "colors"
        )
      )

      # Instantiates a new Vehicles Category View
      @vehiclesView = new ProgramView(
        el: "#vehicles"
        collection: new ProgramsCollection([],
          type: "vehicles"
        )
      )

      # Tells Backbone to start watching for hashchange events
      Backbone.history.start()


    # Backbone.js Routes
    routes:

    # When there is no hash bang on the url, the home method is called
      "": "home"

    # When #category? is on the url, the category method is called
      "category?:type": "category"


    # Home method
    home: ->

      # Programatically changes to the categories page
      $.mobile.changePage "#categories",
        reverse: false
        changeHash: false



    # Category method that passes in the type that is appended to the url hash
    category: (type) ->

      # Stores the current Category View  inside of the currentView variable
      currentView = this[type + "View"]

      # If there are no collections in the current Category View
      unless currentView.collection.length

        # Show's the jQuery Mobile loading icon
        $.mobile.loading "show"

        # Fetches the Collection of Category Models for the current Category View
        currentView.collection.fetch().done ->

          # Programatically changes to the current categories page
          $.mobile.changePage "#" + type,
            reverse: false
            changeHash: false



        # If there already collections in the current Category View
      else

        # Programatically changes to the current categories page
        $.mobile.changePage "#" + type,
          reverse: false
          changeHash: false

