#+--------------------------------------------------------------------+
#  ProgramList.coffee
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
# ProgramList View
#
Ext.define 'Katra.view.program.ProgramList',
  extend: 'Ext.List'
  xtype: 'programlist'

  config:
    onItemDisclosure: true
    emptyText: 'No data found!'
    store: 'Programs'
    items: [
      xtype: 'toolbar'
      docked: 'top'
      style: 'background:darkgray'

      items: [
        xtype: 'searchfield'
        placeHolder: 'Filter or search... '
      ,
        xtype: 'button'
        iconCls: 'search'
        iconMask: true
        ui: 'confirm'
        action: 'search'
      ,
        xtype: 'spacer'
      ,
        xtype: 'button'
        iconCls: 'add'
        iconMask: true
        ui: 'action'
        action: 'add'
      ]
    ]
    itemTpl: [
      '<p>{programName}</p>'
      '<div style=\'font-size: 0.75em; color: darkgray\'>{programSource}</div>'
    ].join('')

