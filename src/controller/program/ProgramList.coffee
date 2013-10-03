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
# ProgramList controller
#
Ext.define 'Katra.controller.program.ProgramList',
  extend: 'Ext.app.Controller'
  config:
    refs:
      programPanelRefreshButton: 'programpanel titlebar button[action=refresh]'
      programList: 'programlist'
      programListSearchField: 'programlist searchfield'
      programListSearchButton: 'programlist toolbar button[action=search]'
      programListAddButton: 'programlist toolbar button[action=add]'

    control:
      programPanelRefreshButton:
        tap: 'onProgramListRefresh'

      programListSearchField:
        keyup: 'onProgramListFilter'

      programListSearchButton:
        tap: 'onProgramListSearch'

      programListAddButton:
        tap: 'onProgramListAddItem'

      programList:
        itemtap: 'onProgramListItemTap'

  
  #+--------------------------------------------------------------------+
  # REFRESH the list
  #+--------------------------------------------------------------------+
  onProgramListRefresh: (element, e) ->
    console.log 'refresh list'

  
  #+--------------------------------------------------------------------+
  # FILTER item(s)
  #+--------------------------------------------------------------------+
  onProgramListFilter: (element, e) ->
    
    # do the filtering of the store here
    searchPattern = @getProgramListSearchField().getValue()
    filterPattern = new RegExp(searchPattern, 'i')
    store = @getProgramList().getStore()
    console.log 'onProgramListFilter - filterData: ' + searchPattern
    
    # reset the filter
    store.clearFilter()
    
    # filter only, if there is a filter value
    return  if searchPattern is ''
    store.filterBy ((record, id) ->
      return true  if filterPattern.test(record.data.programName)
      return true  if filterPattern.test(record.data.programOrigin)
      false
    ), this

  
  #+--------------------------------------------------------------------+
  # SEARCH item(s)
  #+--------------------------------------------------------------------+
  onProgramListSearch: (element, e) ->
    
    # do the search here - f.e. an AJAX call to your server, etc.
    searchPattern = @getProgramListSearchField().getValue()
    console.log 'onProgramListSearch - searchData: ' + searchPattern

  
  #+--------------------------------------------------------------------+
  # ADD item
  #+--------------------------------------------------------------------+
  onProgramListAddItem: (element, e) ->
    
    # add a new item to the store here
    console.log 'onProgramListAddItem'

  
  #+--------------------------------------------------------------------+
  # SELECT item: show the detail view
  #+--------------------------------------------------------------------+
  onProgramListItemTap: (list, index, target, record) ->
    console.log 'onProgramListItemTap'
    
    # load the detail
    navigationView = list.up('navigationview')
    navigationView.push
      title: record.data.programName
      xtype: 'programdetailform'
      record: record


