#+--------------------------------------------------------------------+
#| ProgramsCollection.coffee
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
# ProgramsCollection
#

# Includes file dependencies
define ["jquery", "backbone", "models/ProgramModel"], ($, Backbone, ProgramModel) ->

  # Extends Backbone.Router
  class ProgramsCollection extends Backbone.Collection

    # The Collection constructor
    initialize: (models, options) ->

      # Sets the type instance property (ie. animals)
      @type = options.type


    # Sets the Collection model property to be a Category Model
    model: ProgramModel

    # Sample JSON data that in a real app will most likely come from a REST web service
    jsonArray: [
      category: "animals"
      type: "Pets"
    ,
      category: "animals"
      type: "Farm Animals"
    ,
      category: "animals"
      type: "Wild Animals"
    ,
      category: "colors"
      type: "Blue"
    ,
      category: "colors"
      type: "Green"
    ,
      category: "colors"
      type: "Orange"
    ,
      category: "colors"
      type: "Purple"
    ,
      category: "colors"
      type: "Red"
    ,
      category: "colors"
      type: "Yellow"
    ,
      category: "colors"
      type: "Violet"
    ,
      category: "vehicles"
      type: "Cars"
    ,
      category: "vehicles"
      type: "Planes"
    ,
      category: "vehicles"
      type: "Construction"
    ]

    # Overriding the Backbone.sync method (the Backbone.fetch method calls the sync method when trying to fetch data)
    sync: (method, model, options) ->

      # Local Variables
      # ===============

      # Instantiates an empty array
      categories = []

      # Creates a jQuery Deferred Object
      deferred = $.Deferred()

      # Uses a setTimeout to mimic a real world application that retrieves data asynchronously
      setTimeout (=>

        # Filters the above sample JSON data to return an array of only the correct category type
        categories = _.filter(@jsonArray, (row) =>
          row.category is @type
        )

        # Calls the options.success method and passes an array of objects (Internally saves these objects as models to the current collection)
        options.success categories

        # Triggers the custom `added` method (which the Category View listens for)
        @trigger "added"

        # Resolves the deferred object (this triggers the changePage method inside of the Category Router)
        deferred.resolve()
      ), 1000

      # Returns the deferred object
      deferred
