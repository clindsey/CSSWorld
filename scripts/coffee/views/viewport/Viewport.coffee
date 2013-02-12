define [
      "collections/ViewportTiles"
      "views/viewport/ViewportTile"
      "models/Viewport"
      "collections/Plants"
      "collections/Creatures"
      "models/Plant"
      "views/entities/Plant"
      "models/Creature"
      "views/entities/Creature"
      "models/Heightmap"
      "Alea"
      "Backbone"
    ], (
      viewportTiles,
      ViewportTileView,
      viewportModel,
      plants,
      creatures,
      PlantModel,
      PlantView,
      CreatureModel,
      CreatureView,
      heightmapModel) ->

  ViewportView = Backbone.View.extend
    el: ".map-viewport"

    initialize: ->
      @rnd = new Alea(heightmapModel.get "SEED")

      @render()

      @makePlants()

      @makeCreatures()

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

    makeCreatures: ->
      creatureCount = 100
      giveUpCounter = 100

      heightmapData = heightmapModel.get "data"

      while creatures.length < creatureCount and giveUpCounter > 0
        x = ~~(@rnd() * heightmapModel.get("worldTileWidth"))
        y = ~~(@rnd() * heightmapModel.get("worldTileHeight"))
        stage = ~~(@rnd() * 4)

        unless heightmapData[y][x].get("type") is 255
          giveUpCounter -= 1
          continue

        creature = new CreatureModel x: x, y: y, stage: stage
        creatureView = new CreatureView model: creature

        creatures.add creature

        @$el.append creatureView.render().$el

    makePlants: ->
      plantCount = 100
      giveUpCounter = 100

      heightmapData = heightmapModel.get "data"

      while plants.length < plantCount and giveUpCounter > 0
        x = ~~(@rnd() * heightmapModel.get("worldTileWidth"))
        y = ~~(@rnd() * heightmapModel.get("worldTileHeight"))
        stage = ~~(@rnd() * 4)

        unless heightmapData[y][x].get("type") is 255
          giveUpCounter -= 1
          continue

        plant = new PlantModel x: x, y: y, stage: stage
        plantView = new PlantView model: plant

        plants.add plant

        @$el.append plantView.render().$el

    onViewportMoved: ->
      _.each @grid, (viewportTileView, index) ->
        viewportTileView.type = viewportTiles.at(index).get("type")
        viewportTileView.setBackgroundPosition()
