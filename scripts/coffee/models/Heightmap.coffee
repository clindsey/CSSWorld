define [
      "models/HeightmapChunk"
      "models/ViewportTile"
      "Alea"
      "Backbone"
    ], (
      HeightmapChunkModel,
      ViewportTileModel) ->

  Heightmap = Backbone.Model.extend
    defaults:
      SEED: 20130210

    initialize: ->
      worldChunkWidth = 8
      worldChunkHeight = 8
      chunkWidth = 9
      chunkHeight = 9
      maxElevation = 10

      @set
        worldTileWidth: worldChunkWidth * chunkWidth
        worldTileHeight: worldChunkHeight * chunkHeight

      chunks = @buildChunks worldChunkWidth, worldChunkHeight, chunkWidth, chunkHeight, maxElevation
      @set "data", @generateHeightmap chunks, worldChunkWidth * chunkWidth, worldChunkHeight * chunkHeight, chunkWidth, chunkHeight

    clamp: (index, size) ->
      (index + size) % size

    generateHeightmap: (chunks, worldTileWidth, worldTileHeight, chunkWidth, chunkHeight) ->
      heightmap = []

      for chunkRow, y in chunks
        for chunk, x in chunkRow
          cells = chunk.get "cells"

          for cellRow, cy in cells
            for cell, cx in cellRow
              yIndex = cy + (y * cells.length)
              xIndex = cx + (x * cellRow.length)

              heightmap[yIndex] = [] unless heightmap[yIndex]?
              heightmap[yIndex][xIndex] = new ViewportTileModel(
                  data: cell
                  x: xIndex
                  y: yIndex)

      heightmap

    buildChunks: (worldChunkWidth, worldChunkHeight, chunkWidth, chunkHeight, maxElevation) ->
      SEED = @get "SEED"

      worldTileWidth = worldChunkWidth * chunkWidth

      chunks = []

      for y in [0..worldChunkHeight - 1]
        chunks[y] = []

        for x in [0..worldChunkWidth - 1]
          nw = (new Alea(y * worldTileWidth + x + SEED))() * maxElevation

          if x + 1 is worldChunkWidth
            ne = (new Alea(y * worldTileWidth + SEED))() * maxElevation
          else
            ne = (new Alea(y * worldTileWidth + x + 1 + SEED))() * maxElevation

          if y + 1 is worldChunkHeight
            sw = (new Alea(x + SEED))() * maxElevation

            if x + 1 is worldChunkWidth
              se = (new Alea(SEED)()) * maxElevation
            else
              se = (new Alea(x + 1 + SEED))() * maxElevation
          else
            sw = (new Alea((y + 1) * worldTileWidth + x + SEED))() * maxElevation

            if x + 1 is worldChunkWidth
              se = (new Alea((y + 1) * worldTileWidth + SEED))() * maxElevation
            else
              se = (new Alea((y + 1) * worldTileWidth + x + 1 + SEED))() * maxElevation

          chunks[y][x] = new HeightmapChunkModel
            ne: ne
            nw: nw
            se: se
            sw: sw
            width: chunkWidth
            height: chunkHeight

      chunks

    getArea: (sliceWidth, sliceHeight, centerX, centerY) ->
      dataOut = []

      heightmapData = @get "data"
      dataHeight = heightmapData.length
      xOffset = sliceWidth >> 1
      yOffset = sliceHeight >> 1

      for y in [0..sliceHeight - 1]
        dataWidth = heightmapData[y].length
        dataOut[y] = []

        for x in [0..sliceWidth - 1]
          xIndex = @clamp x - xOffset + centerX, dataWidth
          yIndex = @clamp y - yOffset + centerY, dataHeight

          dataOut[y][x] = heightmapData[yIndex][xIndex]

      dataOut

  new Heightmap
