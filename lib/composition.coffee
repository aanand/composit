class Composition
  @fromImage: (image, width, height) ->
    canvas = document.createElement('canvas')
    canvas.width  = width
    canvas.height = height

    imageRatio  = image.width/image.height
    canvasRatio = canvas.width/canvas.height

    scaleWidth  = null
    scaleHeight = null

    if imageRatio > canvasRatio
      scaleHeight = canvas.height
      scaleWidth = scaleHeight * imageRatio
    else
      scaleWidth = canvas.width
      scaleHeight = scaleWidth / imageRatio

    x = (canvas.width-scaleWidth)/2
    y = (canvas.height-scaleHeight)/2

    canvas.getContext('2d').drawImage(image, x, y, scaleWidth, scaleHeight)

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