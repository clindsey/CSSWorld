define [
      "Backbone"
    ], (
      ) ->

  ViewportTile = Backbone.View.extend
    tagName: "div"

    className: "map-tile"

    initialize: ->
      @listenTo @model, "remove", @remove

    render: ->
      @$el.css
        backgroundPositionX: 0 - ((@model.get("type") % 16) * 16)
        backgroundPositionY: 0 - (~~(@model.get("type") / 16) * 16)

      @
