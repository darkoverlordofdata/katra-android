// Generated by CoffeeScript 1.6.3
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(function(require) {
  var $, Backbone, Program, Programs;
  $ = require("jquery");
  Backbone = require("backbone");
  Program = require("models/Program");
  return Programs = (function(_super) {
    __extends(Programs, _super);

    Programs.prototype.model = Program;

    function Programs() {
      Programs.__super__.constructor.call(this, [
        {
          "id": 1,
          "name": "Test Program",
          "source": "TEST.BAS"
        }, {
          "id": 2,
          "name": "STAR TREK: BY MIKE MAYFIELD",
          "source": "STTR1.bas"
        }, {
          "id": 3,
          "name": "Romulan High Command",
          "source": "romulan.bas"
        }, {
          "id": 4,
          "name": "Another Start Trek",
          "source": "strtrk.bas"
        }, {
          "id": 5,
          "name": "HI!  I'M ELIZA.  WHAT'S YOUR PROBLEM?",
          "source": "eliza.bas"
        }
      ]);
    }

    return Programs;

  })(Backbone.Collection);
});
