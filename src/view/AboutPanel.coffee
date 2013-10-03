#+--------------------------------------------------------------------+
#  AboutPanel.coffee
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
# About View
#
Ext.define 'Katra.view.AboutPanel',
  extend: 'Ext.Panel'
  xtype: "aboutpanel"
  config:
    title: 'About'
    iconCls: 'info'
    scrollable: false
    styleHtmlContent: true
    items: [
      xtype: 'titlebar'
      title: 'About'
      docked: 'top'
    ,

      html:
        """
        <img src="resources/icons/Icon_Android96.png" /><p>
        <blockquote cite="http://darkoverlordofdata.com/katra">Katra is a basic language interpreter
        written in coffee-script and using
        <a href=http://zaach.github.io/jison/>Jison</a>.
        </p><p>Katra has one goal -
        to run StarTrek.bas games from the golden age of basic programming.</blockquote>
        </p>
        <br />
        <div class='star-fleet'>
        <h4><em><div>
        <br />
        </div><div>
        <br />
        </div><div>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;------*------
        </div><div>
        &nbsp;&nbsp;-------------&nbsp;&nbsp;`---&nbsp;&nbsp;------&#39;
        </div><div>
        &nbsp;&nbsp;`--------&nbsp;--&#39;&nbsp;&nbsp;&nbsp;&nbsp;/&nbsp;/
        </div><div>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\\\\-------&nbsp;&nbsp;--
        </div><div>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&#39;-----------&#39;
        </div>
        </h4></em></div>
        """

    ]

