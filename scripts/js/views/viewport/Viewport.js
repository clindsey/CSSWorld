// Generated by CoffeeScript 1.4.0
(function() {

  define(["collections/ViewportTiles", "views/viewport/ViewportTile", "models/Viewport", "collections/Plants", "collections/Creatures", "models/Plant", "views/entities/Plant", "models/Creature", "views/entities/Creature", "models/Heightmap", "Alea", "Backbone"], function(viewportTiles, ViewportTileView, viewportModel, plants, creatures, PlantModel, PlantView, CreatureModel, CreatureView, heightmapModel) {
    var ViewportView;
    return ViewportView = Backbone.View.extend({
      el: ".map-viewport",
      initialize: function() {
        this.rnd = new Alea(heightmapModel.get("SEED"));
        this.render();
        this.makePlants();
        this.makeCreatures();
        return this.listenTo(viewportModel, "moved", this.onViewportMoved);
      },
      render: function() {
        var _this = this;
        this.$el.css({
          width: viewportModel.get("width") * 16,
          height: viewportModel.get("height") * 16
        });
        this.grid = [];
        viewportTiles.each(function(viewportTileModel) {
          var viewportTileView;
          viewportTileView = new ViewportTileView;
          viewportTileView.type = viewportTileModel.get("type");
          _this.$el.append(viewportTileView.render().$el);
          return _this.grid.push(viewportTileView);
        });
        return this;
      },
      makeCreatures: function() {
        var creature, creatureCount, creatureView, giveUpCounter, heightmapData, stage, x, y, _results;
        creatureCount = 100;
        giveUpCounter = 100;
        heightmapData = heightmapModel.get("data");
        _results = [];
        while (creatures.length < creatureCount && giveUpCounter > 0) {
          x = ~~(this.rnd() * heightmapModel.get("worldTileWidth"));
          y = ~~(this.rnd() * heightmapModel.get("worldTileHeight"));
          stage = ~~(this.rnd() * 4);
          if (heightmapData[y][x].get("type") !== 255) {
            giveUpCounter -= 1;
            continue;
          }
          creature = new CreatureModel({
            x: x,
            y: y,
            stage: stage
          });
          creatureView = new CreatureView({
            model: creature
          });
          creatures.add(creature);
          _results.push(this.$el.append(creatureView.render().$el));
        }
        return _results;
      },
      makePlants: function() {
        var giveUpCounter, heightmapData, plant, plantCount, plantView, stage, x, y, _results;
        plantCount = 100;
        giveUpCounter = 100;
        heightmapData = heightmapModel.get("data");
        _results = [];
        while (plants.length < plantCount && giveUpCounter > 0) {
          x = ~~(this.rnd() * heightmapModel.get("worldTileWidth"));
          y = ~~(this.rnd() * heightmapModel.get("worldTileHeight"));
          stage = ~~(this.rnd() * 4);
          if (heightmapData[y][x].get("type") !== 255) {
            giveUpCounter -= 1;
            continue;
          }
          plant = new PlantModel({
            x: x,
            y: y,
            stage: stage
          });
          plantView = new PlantView({
            model: plant
          });
          plants.add(plant);
          _results.push(this.$el.append(plantView.render().$el));
        }
        return _results;
      },
      onViewportMoved: function() {
        return _.each(this.grid, function(viewportTileView, index) {
          viewportTileView.type = viewportTiles.at(index).get("type");
          return viewportTileView.setBackgroundPosition();
        });
      }
    });
  });

}).call(this);
