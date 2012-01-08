# Use the `jQuery.ready` shortcut.
$ ->

  # A color model with default `background` and `text` attributes.
  class Color extends Backbone.Model
    defaults:
      "background": "#f5f5f5"
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
      if @length > 1
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
      "click .btn.add": "update_colors"
      "click .btn.undo": "undo_color"

    # On initialization, the two inputs are saved as `@text` and `@background`.
    # A new `ColorList` collection is created and functions are bound to both
    # the `add` and `undo` events.
    initialize: ->
      @text = @$('#new-text')
      @background = @$('#new-background')
      @collection = new ColorList
      @collection.bind('add', @change_color)
      @collection.bind('undo', @change_color)

    # Change the view's `@el` element's `background` and `color` CSS.
    change_color: (color) =>
      [background, text] = [color.get('background'), color.get('text')]
      $(@el).css
        background: background
        color: text
      if @collection.length > 1
        background = background.replace("#", "")
        text = text.replace("#", "")
      else
        [background, text] = ["", ""]
      @background.val(background)
      @text.val(text)

    # Create a new `Color` model if the current `event` was either an Enter
    # `keypress` or `click`. The model is created using the values from the
    # `input` fields.
    update_colors: (event) ->
      if event.keyCode is 13 or event.type is "click"
        background = @check_hash @background.val()
        text = @check_hash @text.val()
        @collection.create
          background: background
          text: text

    # Check to see if a hash needs to be added to the color value.
    check_hash: (color) ->
      regex = /[0-9a-fA-F]/g
      match = color.match(regex)
      if match and match.length is color.length
        color = "#" + color
      color

    # Invoke the `undo` method on this view's `ColorList` collection.
    undo_color: (event) ->
      @collection.undo()


  # Create a new `ColorView` under the global `window.App` namespace.
  window.App = new ColorView

  # Initialize Bootstrap's `twipsy` plugin.
  $('[rel="twipsy"]').twipsy()
