define [
      "Backbone"
    ], (
      ) ->

  ViewportTile = Backbone.View.extend
    tagName: "div"

    className: "map-tile"

    render: ->
      @setBackgroundPosition()

    setBackgroundPosition: ->
      backgroundPositionX = 0 - ((@type % 16) * 16)
      backgroundPositionY = 0 - (~~(@type / 16) * 16)

      @$el.css
        backgroundPosition: "#{backgroundPositionX}px #{backgroundPositionY}px"

      @
