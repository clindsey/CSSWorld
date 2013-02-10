define [
      "collections/ViewportTiles"
      "views/viewport/ViewportTile"
      "models/Viewport"
      "Backbone"
    ], (
      viewportTiles,
      ViewportTileView,
      viewportModel) ->

  ViewportView = Backbone.View.extend
    el: "#tile-viewport"

    initialize: ->
      @render()

      @listenTo viewportModel, "moved", @render

      $(document).keydown (jqEvent) =>
        viewportX = viewportModel.get "x"
        viewportY = viewportModel.get "y"

        if jqEvent.keyCode is 37 # left
          viewportX -= 1
        else if jqEvent.keyCode is 38 # up
          viewportY -= 1
        else if jqEvent.keyCode is 39 # right
          viewportX += 1
        else if jqEvent.keyCode is 40 # down
          viewportY += 1

        viewportModel.set
          x: viewportX
          y: viewportY

    render: ->
      viewportTiles.each (viewportTileModel) =>
        viewportTileView = new ViewportTileView model: viewportTileModel

        @$el.append viewportTileView.render().$el

      @
