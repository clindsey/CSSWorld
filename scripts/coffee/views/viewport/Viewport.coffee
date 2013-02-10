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

      @listenTo viewportModel, "moved", @updateViewport

      $(document).keydown (jqEvent) =>
        viewportX = viewportModel.get "x"
        viewportY = viewportModel.get "y"

        vx = 0
        vy = 0

        if jqEvent.keyCode is 37 # left
          vx -= 1
        else if jqEvent.keyCode is 38 # up
          vy -= 1
        else if jqEvent.keyCode is 39 # right
          vx += 1
        else if jqEvent.keyCode is 40 # down
          vy += 1

        viewportModel.set
          x: viewportX + vx
          y: viewportY + vy

        unless vx is 0 and vy is 0
          jqEvent.preventDefault()
          jqEvent.stopPropagation()
          return false

    render: ->
      @grid = []

      viewportTiles.each (viewportTileModel) =>
        viewportTileView = new ViewportTileView
        viewportTileView.type = viewportTileModel.get "type"

        @$el.append viewportTileView.render().$el

        @grid.push viewportTileView

      @

    updateViewport: ->
      _.each @grid, (viewportTileView, index) ->
        viewportTileView.type = viewportTiles.at(index).get("type")
        viewportTileView.setBackgroundPosition()
