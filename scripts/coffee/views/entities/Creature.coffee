define [
      "views/entities/Entity"
      "models/Heightmap"
    ], (
      EntityView,
      heightmapModel) ->

  Creature = EntityView.extend
    tagName: "div"

    className: "creature-tile creature-moving entity-title"

    machineJson: {
      identifier: "idle"
      strategy: "prioritised"
      children: [
        identifier: "move"
        strategy: "sequential"
        children: [
          { identifier: "findPath" },
          { identifier: "followPath" },
          { identifier: "idle" }
        ]
      ]
    },

    render: ->
      EntityView.prototype.render.call this

      @moveTimer = @interval 1000 / 2, =>
        @travel()

      @

    interval: (time, callback) => setInterval callback, time

    travel: ->
      localArea = heightmapModel.getArea 5, 5, @model.get("x"), @model.get("y")

      if localArea[2 + 1][2].get("type") is 255
        @model.set "y", @model.get("y") + 1
      else
        clearInterval @moveTimer
