(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  $(function() {
    var Color, ColorList, ColorView;
    Color = (function(_super) {

      __extends(Color, _super);

      function Color() {
        Color.__super__.constructor.apply(this, arguments);
      }

      Color.prototype.defaults = {
        "background": "#eee",
        "text": "#222"
      };

      return Color;

    })(Backbone.Model);
    ColorList = (function(_super) {

      __extends(ColorList, _super);

      function ColorList() {
        ColorList.__super__.constructor.apply(this, arguments);
      }

      ColorList.prototype.model = Color;

      ColorList.prototype.localStorage = new Store('colors');

      ColorList.prototype.initialize = function() {
        return this.add(new Color);
      };

      ColorList.prototype.undo = function() {
        if (this.length > 2) this.remove(this.last());
        return this.trigger('undo', this.last());
      };

      return ColorList;

    })(Backbone.Collection);
    ColorView = (function(_super) {

      __extends(ColorView, _super);

      function ColorView() {
        this.change_color = __bind(this.change_color, this);
        ColorView.__super__.constructor.apply(this, arguments);
      }

      ColorView.prototype.el = ".hero-unit";

      ColorView.prototype.events = {
        "keypress #new-background": "update_colors",
        "keypress #new-text": "update_colors",
        "click .btn": "update_colors",
        "click .undo": "undo_color"
      };

      ColorView.prototype.initialize = function() {
        this.text = this.$('#new-text');
        this.background = this.$('#new-background');
        this.collection = new ColorList;
        this.collection.bind('add', this.change_color);
        return this.collection.bind('undo', this.change_color);
      };

      ColorView.prototype.change_color = function(color) {
        return $(this.el).css({
          background: color.get('background'),
          color: color.get('text')
        });
      };

      ColorView.prototype.update_colors = function(event) {
        if (event.keyCode === 13 || event.type === "click") {
          return this.collection.create({
            background: this.background.val(),
            text: this.text.val()
          });
        }
      };

      ColorView.prototype.undo_color = function(event) {
        return this.collection.undo();
      };

      return ColorView;

    })(Backbone.View);
    return window.App = new ColorView;
  });

}).call(this);
