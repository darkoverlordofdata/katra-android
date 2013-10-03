#+--------------------------------------------------------------------+
#  ReplInput.coffee
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
# ReplInput View
#
Ext.define 'Katra.view.repl.ReplInput',
  extend: 'Ext.form.Panel'
  xtype: 'replinput'

  config:
    items: [
      {
        html:
          """
          Enter code below: <br />

          """
      },
      {
        xtype: 'textfield'
        name : 'code'
        maxLength: 80
        label: ''
      }
    ]
    listeners: [
      delegate: "#backButton"
      event: "tap"
      fn: "onBackButtonTap"

    ]

