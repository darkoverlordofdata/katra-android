#+--------------------------------------------------------------------+
#  Programs.coffee
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
# Program store
#
Ext.define 'Katra.store.Programs',
  extend: 'Ext.data.Store'

  requires: ['Katra.model.Program']

  config:

    model: 'Katra.model.Program'
    autoLoad: true
    proxy:
      type: 'ajax'
      url: 'resources/data/ProgramData.json'
      reader:
        type: 'json'
        rootProperty: 'programs'

    sorters: [
      property: 'programName'
      direction: 'ASC'
    ]

