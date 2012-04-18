class Throttler
  constructor: (@delay) ->
    @queue = []
    @interval = window.setInterval(@emit, @delay)

  write: (object) ->
    @queue.push(object)

  emit: =>
    if object = @queue.pop()
      @onEmit(object)

module.exports = Throttler