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
  extend: "Ext.form.Panel"
  requires: "Ext.form.FieldSet"
  xtype: 'replpanel'
  config:
    scrollable: false
    iconCls: 'compose'

    items: [
      xtype: "toolbar"
      docked: "top"
      title: "Repl"
      items: [
        xtype: "button"
        ui: "back"
        text: "Home"
        itemId: "backButton"
      ,
        xtype: "spacer"
      ,
        xtype: "button"
        ui: "action"
        text: "Run"
        itemId: "runButton"
      ]
    ,
      xtype: "replinput"
      title: 'Repl'
    ]



