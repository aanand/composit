class Composition
  constructor: (@canvas, @width, @height) ->
    @canvas.width = @width
    @canvas.height = @height
    @images = []

  addImageUrls: (imageUrls) ->
    imageUrls.forEach (url) =>
      image = new Image
      image.src = url
      image.onload = =>
        @images.push(image)
        @render()

  render: ->
    @canvas.width = @canvas.width
    ctx = @canvas.getContext('2d')

    for i in [0 ... @images.length]
      ctx.globalAlpha = 1.0 / (i+1)
      ctx.drawImage(@images[i], 0, 0)

    @didRender(@images.length)

module.exports = Composition