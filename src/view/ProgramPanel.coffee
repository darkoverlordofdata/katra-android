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
# Program View
#
Ext.define 'Katra.view.ProgramPanel',
  extend: 'Ext.NavigationView'
  xtype: 'programpanel'
  requires: ['Katra.view.program.ProgramList', 'Katra.view.program.ProgramDetail']
  config:
    title: 'Programs'
    iconCls: 'list'
    scrollable: false
    navigationBar:
      items: [
        xtype: 'button'
        align: 'right'
        iconCls: 'refresh'
        iconMask: true
        hidden: false
        action: 'refresh'
      ,
        xtype: 'button'
        align: 'right'
        iconCls: 'action'
        iconMask: true
        hidden: true
        action: 'action'
      ]

    items: [
      title: 'Programs'
      xtype: 'programlist'
    ]

