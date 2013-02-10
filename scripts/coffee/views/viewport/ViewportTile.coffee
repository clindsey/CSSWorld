define [
      "Backbone"
    ], (
      ) ->

  ViewportTile = Backbone.View.extend
    tagName: "div"

    className: "map-tile"

    render: ->
      @$el.html @model.get "data"

      colorBit = ~~((@model.get("data") / 10) * 255)

      @$el.css
        backgroundColor: "rgb(#{colorBit}, #{colorBit}, #{colorBit})"

       @
