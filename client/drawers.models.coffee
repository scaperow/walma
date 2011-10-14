
models = NS "PWB.drawers.models"

now = -> new Date().getTime()

class models.ToolModel extends Backbone.Model


class models.StatusModel extends Backbone.Model

  defaults:
    status: "starting"
    operationCount: 0
    inHistory: 0
    drawnFromHistory: 0
    historyDrawTime: "under 1"

  constructor: ->
    super

    @bind "change", =>
      if @start
        diff = (now() - @start) / 1000
        diff or= "under 1"
        @set historyDrawTime: diff, silent: true


  loadOperations: (history) ->

    operationCount = _.reduce history, (memo, draw) ->
      return memo unless draw?.shape?.moves
      memo + draw.shape.moves.length
    , 0

    @set
      operationCount: operationCount
      inHistory: operationCount


  incOperationCount: (amount) ->
    amount ?= 0
    @set operationCount: @get("operationCount") + amount

  incDrawnFromHistory: (amount) ->
    @start ?= now()
    amount ?= 0
    @set drawnFromHistory: @get("drawnFromHistory") + amount

  drawnHistory: ->
    @start = null
    @set drawnFromHistory: @get("inHistory")



  addDraw: (draw) ->
    @incOperationCount draw.shape.moves.length

  addShape: (shape) ->
    @incOperationCount shape.moves.length

