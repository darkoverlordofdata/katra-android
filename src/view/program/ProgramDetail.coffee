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
# ProgramDetail View
#
Ext.define 'Katra.view.program.ProgramDetail',
  extend: 'Ext.form.Panel'
  xtype: 'programdetailform'

  config:
    items: [
      xtype: 'fieldset'
      title: 'Program Details'
      defaults:
        labelAlign: 'left'
        labelWidth: '35%'
        labelWrap: true

      items: [
        xtype: 'textfield'
        label: 'ID'
        name: 'programId'
        readOnly: true
      ,
        xtype: 'textfield'
        label: 'Name'
        name: 'programName'
      ,
        xtype: 'textfield'
        label: 'Source'
        name: 'programSource'
      ]
    ,
      xtype: 'spacer'
      height: '2em'
    ,
      xtype: 'button'
      width: '100%'
      height: '3em'
      text: 'Save Changes'
      ui: 'action'
      action: 'save'
    ]

