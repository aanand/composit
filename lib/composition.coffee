class Composition
  @fromImage: (image) ->
    new Composition(image, 1)

  @compose: (components, width, height) ->
    canvas = document.createElement('canvas')
    canvas.width = width
    canvas.height = height

    ctx = canvas.getContext('2d')

    currentWeight = 0

    components.forEach (c) ->
      newWeight = c.weight + currentWeight
      c.render(ctx, c.weight / newWeight)
      currentWeight = newWeight

    new Composition(canvas, currentWeight)

  constructor: (@image, @weight) ->

  render: (ctx, alpha) ->
    ctx.globalAlpha = alpha
    ctx.drawImage(@image, 0, 0)

module.exports = Composition