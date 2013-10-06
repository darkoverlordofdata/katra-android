#+--------------------------------------------------------------------+
#| ProgramView.coffee
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
define (require) ->

  $         = require("jquery")
  Backbone  = require("backbone")
  JST       = require("JST")
  Programs  = require("collections/Programs")
  #require 'prettify'
  #require 'basic'


  class ProgramView extends Backbone.View

    constructor: (id) ->
      @id = parseInt(id, 10)


    render: ->
      #$('.menu a').removeClass 'active'
      #$('.menu a[href="#"]').parent().addClass 'active'

      programs = new Programs
      @program = programs.get(@id)
      $.get "bas/"+@program.get('source'), (data) =>
        $("#content").html JST.program(program: @program.toJSON(), source:data)
        $('[data-role="content"]').trigger 'create'
        #setTimeout prettyPrint, 1