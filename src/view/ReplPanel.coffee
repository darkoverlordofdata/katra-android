#+--------------------------------------------------------------------+
#  ReplPanel.coffee
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
# Repl View
#
Ext.define 'Katra.view.ReplPanel',
  extend: 'Ext.NavigationView'
  xtype: 'replpanel'
  requires: ['Katra.view.repl.ReplInput']
  config:
    title: 'Repl'
    iconCls: 'compose'
    scrollable: false
    navigationBar:
      items: [
        xtype: 'button'
        align: 'right'
        iconCls: 'action'
        iconMask: true
        hidden: false
      ]

    items: [
      title: 'Repl'
      xtype: 'replinput'
    ]



