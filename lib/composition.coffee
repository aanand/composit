class Composition
  @fromImage: (image, width, height) ->
    canvas = document.createElement('canvas')
    canvas.width  = width
    canvas.height = height

    canvas.getContext('2d').drawImage(image, (width-image.width)/2, (height-image.height)/2)

    new Composition(canvas, 1)

  @compose: (components) ->
    canvas = document.createElement('canvas')
    canvas.width  = components[0].canvas.width
    canvas.height = components[0].canvas.height

    ctx = canvas.getContext('2d')

    currentWeight = 0

    components.forEach (c) ->
      newWeight = c.weight + currentWeight
      c.render(ctx, c.weight / newWeight)
      currentWeight = newWeight

    new Composition(canvas, currentWeight)

  constructor: (@canvas, @weight) ->

  render: (ctx, alpha) ->
    ctx.globalAlpha = alpha
    ctx.drawImage(@canvas, 0, 0)

module.exports = Composition