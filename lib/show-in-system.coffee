{$} = require 'atom'
shell = require 'shell'
child_process = require 'child_process'
{CompositeDisposable} = require 'event-kit'

module.exports =
  configDefaults: {
    app: 'Terminal.app'
    args: ''
  }

  # Register open, show and terminal commnads
  activate: ->
    @disposables = new CompositeDisposable
    @disposables.add atom.commands.add('.tab, .tree-view .selected', {
      'show-in-system:show': (event) => @show(event.currentTarget)
      'show-in-system:open': (event) => @open(event.currentTarget)
      'show-in-system:terminal': (event) => @terminal(event.currentTarget)
    })

  # Cleanup
  deactivate: -> @disposables.dispose()

  # Call native/shell open item in folder method for the given view.
  show: (target) ->
    path = @getPath(target)
    if !path
      console.warn('Show in system: Path not found. File not saved?')
    shell.showItemInFolder(path) if path

  # Call native/shell open item method for the given view.
  open: (target) ->
    path = @getPath(target)
    if !path
      console.warn('Show in system: Path not found. File not saved?')
    shell.openItem(path) if path

  terminal: (target) ->
    path = @getPath(target)
    if !path
      console.warn('Show in system: Path not found. File not saved?')
    app = atom.config.get('show-in-system.app')
    args = atom.config.get('show-in-system.args')
    child_process.exec "#{app} #{args} #{path}" if path

  # Extract the path from the target: can be a tree-view or tab item.
  getPath: (target) -> return target.getPath?() ? target.item?.getPath()
