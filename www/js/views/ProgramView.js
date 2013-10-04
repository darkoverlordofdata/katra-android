// Generated by CoffeeScript 1.6.3
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(["jquery", "backbone", "models/ProgramModel"], function($, Backbone, ProgramModel) {
  var ProgramView, _ref;
  return ProgramView = (function(_super) {
    __extends(ProgramView, _super);

    function ProgramView() {
      _ref = ProgramView.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    ProgramView.prototype.initialize = function() {
      return this.collection.on("added", this.render, this);
    };

    ProgramView.prototype.render = function() {
      this.template = _.template($("script#categoryItems").html(), {
        collection: this.collection
      });
      this.$el.find("ul").html(this.template);
      return this;
    };

    return ProgramView;

  })(Backbone.View);
});