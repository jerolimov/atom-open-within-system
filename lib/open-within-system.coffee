{$} = require 'atom'
shell = require 'shell'

module.exports =
  # Register open and show commnads
  activate: ->
    atom.workspaceView.command 'open-within-system:show', (event) =>
      @show(@getView(event.target))
    atom.workspaceView.command 'open-within-system:open', (event) =>
      @open(@getView(event.target))
  
  # Cleanup
  deactivate: ->
    atom.workspaceView.off 'open-within-system:show'
    atom.workspaceView.off 'open-within-system:open'
  
  # Call native/shell open item in folder method for the given view.
  show: (view) ->
    path = @getPath(view)
    if !path
      console.warn('Open in shell: Path not found. File not saved?')
    shell.showItemInFolder(path) if path
  
  # Call native/shell open item method for the given view.
  open: (view) ->
    path = @getPath(view)
    if !path
      console.warn('Open in shell: Path not found. File not saved?')
    shell.openItem(path) if path
  
  # Get (all) parent view(s) with class type file, directory OR tab.
  # The first one will be our selected item...
  getView: (node) ->
    return $(node).parents('.file, .directory, .tab').view()
  
  # Extract the path from the view (item). Supports view elements from
  # the tree-view and the tab-view module.
  getPath: (view) ->
    if !view or !view.length
      console.error('Open in shell: View not found!')
    else if view.is('.file') || view.is('.directory')
      return view.getPath()
    else if view.is('.tab')
      return view.item.getPath()
    else
      console.error('Open in shell: Unexpected view type!')
  
