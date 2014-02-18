define [
      "models/Plant"
      "Backbone"
    ], (
      PlantModel) ->

  Plants = Backbone.Collection.extend
    model: PlantModel

    initialize: ->

  new Plants
