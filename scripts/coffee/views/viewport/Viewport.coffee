define [
      "collections/ViewportTiles"
      "views/viewport/ViewportTile"
      "models/Viewport"
      "collections/Plants"
      "models/Plant"
      "views/Plant"
      "models/Heightmap"
      "Alea"
      "Backbone"
    ], (
      viewportTiles,
      ViewportTileView,
      viewportModel,
      plants,
      PlantModel,
      PlantView,
      heightmapModel) ->

  ViewportView = Backbone.View.extend
    el: ".map-viewport"

    initialize: ->
      @render()

      @makePlants()

      @listenTo viewportModel, "moved", @onViewportMoved

    render: ->
      @$el.css
        width: viewportModel.get("width") * 16
        height: viewportModel.get("height") * 16

      @grid = []

      viewportTiles.each (viewportTileModel) =>
        viewportTileView = new ViewportTileView
        viewportTileView.type = viewportTileModel.get "type"

        @$el.append viewportTileView.render().$el

        @grid.push viewportTileView

      @

    makePlants: ->
      plantCount = 100
      giveUpCounter = 100

      rnd = new Alea(heightmapModel.get "SEED")
      heightmapData = heightmapModel.get "data"

      while plants.length < plantCount and giveUpCounter > 0
        x = ~~(rnd() * heightmapModel.get("worldTileWidth"))
        y = ~~(rnd() * heightmapModel.get("worldTileHeight"))

        unless heightmapData[y][x].get("type") is 255
          giveUpCounter -= 1
          continue

        plant = new PlantModel x: x, y: y
        plantView = new PlantView model: plant

        plants.add plant

        @$el.append plantView.render().$el

    onViewportMoved: ->
      _.each @grid, (viewportTileView, index) ->
        viewportTileView.type = viewportTiles.at(index).get("type")
        viewportTileView.setBackgroundPosition()
