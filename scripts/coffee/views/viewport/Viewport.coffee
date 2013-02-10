define [
      "collections/ViewportTiles"
      "views/viewport/ViewportTile"
      "Backbone"
    ], (
      viewportTiles,
      ViewportTileView) ->

  ViewportView = Backbone.View.extend
    el: "#tile-viewport"

    initialize: ->
      @render()

    render: ->
      viewportTiles.each (viewportTileModel) =>
        viewportTileView = new ViewportTileView model: viewportTileModel

        @$el.append viewportTileView.render().$el

      @


