define [
      "models/Viewport"
      "models/Heightmap"
      "Backbone"
    ], (
      viewportModel,
      heightmapModel) ->

  Plant = Backbone.View.extend
    tagName: "div"

    className: "plant-tile"

    initialize: ->
      @listenTo viewportModel, "moved", @onViewportMoved

    render: ->
      @setPosition()

      @

    onViewportMoved: ->
      @setPosition()

    setPosition: ->
      centerX = ~~(viewportModel.get("width") / 2)
      centerY = ~~(viewportModel.get("height") / 2)
      viewX = viewportModel.get "x"
      viewY = viewportModel.get "y"
      x = (@model.get("x") - viewX) + centerX
      y = (@model.get("y") - viewY) + centerY

      @$el.css
        left: x * 16
        top: y * 16
