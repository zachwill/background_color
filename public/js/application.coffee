# Use the `jQuery.ready` shortcut.
$ ->

  # A color model with default `background` and `text` attributes.
  class Color extends Backbone.Model
    defaults:
      "background": "#eee"
      "text": "#222"


  # A collection for the `Color` models that uses `localStorage` rather
  # than a remote database.
  class ColorList extends Backbone.Collection
    model: Color

    localStorage: new Store('colors')

    initialize: ->
      @add new Color

    # The `undo` method removes the last Color item from the collection and
    # triggers an `undo` event with the new last item.
    undo: ->
      if @length > 2
        @remove @last()
      @trigger 'undo', @last()


  # The view that changes the background and text colors of the `.hero-unit`
  # element based on changes in the `ColorList` collection.
  class ColorView extends Backbone.View
    el: ".hero-unit"

    # Events are listed that will update the web page's UI.
    events:
      "keypress #new-background": "update_colors"
      "keypress #new-text": "update_colors"
      "click .btn": "update_colors"
      "click .undo": "undo_color"
      "focus input": "add_hash"
      "blur input": "remove_hash"

    # On initialization, the two inputs are saved as `@text` and `@background`.
    # A new `ColorList` collection is created and functions are bound to both
    # the `add` and `undo` events.
    initialize: ->
      @text = @$('#new-text')
      @background = @$('#new-background')
      @collection = new ColorList
      @collection.bind('add', @change_color)
      @collection.bind('undo', @change_color)

    add_hash: (event) ->
      self = $(event.target)
      value = self.val()
      if value is '' then self.val('#')

    remove_hash: (event) ->
      self = $(event.target)
      value = self.val()
      if value is '#' then self.val('')

    change_color: (color) =>
      $(@el).css
        background: color.get('background')
        color: color.get('text')

    update_colors: (event) ->
      if event.keyCode is 13 or event.type is "click"
        @collection.create
          background: @background.val()
          text: @text.val()

    undo_color: (event) ->
      @collection.undo()

  window.App = new ColorView
