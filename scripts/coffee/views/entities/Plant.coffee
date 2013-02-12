define [
      "views/entities/Entity"
    ], (
      EntityView) ->

  Plant = EntityView.extend
    tagName: "div"

    className: "plant-tile entity-title"

    render: ->
      EntityView.prototype.render.call this

      @setStage()

      @

    setStage: ->
      @$el.css
        backgroundPosition: "-#{@model.get("stage") * 16}px 0"
