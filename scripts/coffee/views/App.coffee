define [
      "views/viewport/Viewport"
      "Backbone"
    ], (
      ViewportView) ->

  AppView = Backbone.View.extend
    initialize: ->
      new ViewportView
