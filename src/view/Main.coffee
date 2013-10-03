#+--------------------------------------------------------------------+
#  Main.coffee
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
# Katra Main View
#


Ext.define 'Katra.view.Main',
  extend: 'Ext.tab.Panel'
  xtype: 'main'
  requires: [
    'Katra.view.ProgramPanel'
    'Katra.view.ReplPanel'
    'Katra.view.AboutPanel'
  ]

  config:

    tabBar:
      docked: 'bottom'

    items: [
      xtype: 'programpanel'
    ,
      xtype: 'replpanel'
    ,
      xtype: 'aboutpanel'
    ]

