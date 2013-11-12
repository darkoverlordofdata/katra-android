// Generated by CoffeeScript 1.6.3
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(function(require) {
  var $, Backbone, JST, ReplView, _ref;
  $ = require("jquery");
  Backbone = require("backbone");
  JST = require("JST");
  require('jqueryconsole');
  require('rte');
  require('katra');
  require('kc');
  return ReplView = (function(_super) {
    __extends(ReplView, _super);

    function ReplView() {
      _ref = ReplView.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    ReplView.prototype.render = function() {
      $("#content").html(JST.repl());
      $('[data-role="content"]').trigger('create');
      return this;
    };

    return ReplView;

  })(Backbone.View);
});
