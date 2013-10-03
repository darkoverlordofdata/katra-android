#+--------------------------------------------------------------------+
#  Program.coffee
#+--------------------------------------------------------------------+
#  Copyright DarkOverlordOfData (c) 2012 - 2013
#+--------------------------------------------------------------------+
#
#  This file is a part of Katra
#
#  Katra is free software you can copy, modify, and distribute
#  it under the terms of the MIT License
#
#+--------------------------------------------------------------------+
#

#
# Program Data Model
#
Ext.define 'Katra.model.Program',
  extend: 'Ext.data.Model'

  config:

    #
    # Field names in the data model
    #
    fields: [

      name: 'programId'
      type: 'string'
    ,
      name: 'programName'
      type: 'string'
    ,
      name: 'programSource'
      type: 'string'
    ]

    #
    # Validation rules
    #
    validations: [

      type: "presence"
      field: "programId"
    ,
      type: "presence"
      field: "programName"
      message: "Please enter a name for this program."
    ,
      type: "presence"
      field: "programSource"
      message: "Please enter a source location for this program."
    ]

