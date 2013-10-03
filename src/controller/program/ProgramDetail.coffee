#+--------------------------------------------------------------------+
#  ProgramDetail.coffee
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
# ProgramDetail controller
#
Ext.define 'Katra.controller.program.ProgramDetail',
  extend: 'Ext.app.Controller'
  config:
    refs:
      programPanelActionButton: 'programpanel titlebar button[action=action]'
      programDetail: 'programdetailform'
      programDetailSaveButton: 'programdetailform button[action=save]'

    control:
      programPanelActionButton:
        tap: 'onProgramDetailAction'

      programDetailSaveButton:
        tap: 'onProgramDetailSave'

  
  #+--------------------------------------------------------------------+
  # ACTION...
  #+--------------------------------------------------------------------+
  onProgramDetailAction: (element, e) ->
    console.log 'onProgramDetailAction'

  
  #+--------------------------------------------------------------------+
  # SAVE item
  #+--------------------------------------------------------------------+
  onProgramDetailSave: (element, e) ->
    console.log 'onProgramDetailSave'

