$ ->

  class Color extends Backbone.Model
    defaults:
      "background": "#eee"
      "text": "#222"


  class ColorList extends Backbone.Collection
    model: Color

    localStorage: new Store('colors')

    initialize: ->
      @add new Color

    undo: ->
      if @length > 2
        @remove @last()
      @trigger 'undo', @last()


  class ColorView extends Backbone.View
    el: ".hero-unit"

    events:
      "keypress #new-background": "update_colors"
      "keypress #new-text": "update_colors"
      "click .btn": "update_colors"
      "click .undo": "undo_color"

    initialize: ->
      @text = @$('#new-text')
      @background = @$('#new-background')
      @collection = new ColorList
      @collection.bind('add', @change_color)
      @collection.bind('undo', @change_color)

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
