#+--------------------------------------------------------------------+
#  ProgramPanel.coffee
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
# ProgramPanel controller
#
Ext.define 'Katra.controller.ProgramPanel',
  extend: 'Ext.app.Controller'
  config:
    refs:
      programPanelNavigationView: 'programpanel'
      programPanelRefreshButton: 'programpanel titlebar button[action=refresh]'
      programPanelEditButton: 'programpanel titlebar button[action=action]'

    control:
      programPanelNavigationView:
        activeitemchange: 'onProgramPanelActiveItemChange'

  
  #+--------------------------------------------------------------------+
  # SHOW the list
  #+--------------------------------------------------------------------+
  onProgramPanelActiveItemChange: (navigationView, value, oldValue) ->
    console.log 'onProgramPanelActiveItemChange'
    newValue = value.getItemId().split('-')[1]
    oldValue = oldValue.getItemId().split('-')[1]
    oldNewValue = oldValue + '-' + newValue
    switch oldNewValue
      when 'programlist-programdetailform'
        
        #console.log('>>> show detail form');
        @getProgramPanelRefreshButton().setHidden true
        @getProgramPanelEditButton().setHidden false
      when 'programdetailform-programlist'
        
        #console.log('<<< quit detail form');
        @getProgramPanelRefreshButton().setHidden false
        @getProgramPanelEditButton().setHidden true

