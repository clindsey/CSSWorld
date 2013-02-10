define [
      "models/Heightmap"
      "models/ViewportTile"
      "Backbone"
    ], (
      heightmap,
      ViewportTileModel) ->

  ViewportTiles = Backbone.Collection.extend
    model: ViewportTileModel

    initialize: ->
      tiles = []

      for tileRow in heightmap.getArea 10, 10, 0, 0
        for tile in tileRow
          tiles.push tile

      @update tiles

  new ViewportTiles
