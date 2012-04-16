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
      c.render(ctx, c.weight / newWeight, width, height)
      currentWeight = newWeight

    new Composition(canvas, currentWeight)

  constructor: (@image, @weight) ->

  render: (ctx, alpha, canvasWidth, canvasHeight) ->
    ctx.globalAlpha = alpha
    ctx.drawImage(@image, (canvasWidth - @image.width)/2, (canvasHeight - @image.height)/2)

module.exports = Composition