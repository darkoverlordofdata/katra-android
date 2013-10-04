#+--------------------------------------------------------------------+
#| ProgramViewfee
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
# ProgramView
#

# Includes file dependencies
define ["jquery", "backbone", "models/ProgramModel"], ($, Backbone, ProgramModel) ->

  # Extends Backbone.View
  class ProgramView extends Backbone.View

    # The View Constructor
    initialize: ->

      # The render method is called when Category Models are added to the Collection
      @collection.on "added", @render, this


    # Renders all of the Category models on the UI
    render: ->

      # Sets the view's template property
      @template = _.template($("script#categoryItems").html(),
        collection: @collection
      )

      # Renders the view's template inside of the current listview element
      @$el.find("ul").html @template

      # Maintains chainability
      @
