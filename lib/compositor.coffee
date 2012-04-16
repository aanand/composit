Composition = require('composition')

class Compositor
  maxComponents: 10

  constructor: (@canvas, @width, @height) ->
    @canvas.width = @width
    @canvas.height = @height
    @components = []

  addImageUrls: (imageUrls) ->
    imageUrls.forEach (url) =>
      image = new Image
      image.src = url
      image.onload = => @addImage(image)

  addImage: (image) ->
    @components.unshift(Composition.fromImage(image, @width, @height))

    if @components.length > @maxComponents
      a = @components.shift()
      b = @components.shift()
      @components.unshift(Composition.compose([a, b]))
      @components = @components.sortBy((c) -> c.weight)

    console.log "component weights: %s", @components.map((c) -> c.weight).join(", ")

    @render()

  render: ->
    topLevelComp = Composition.compose(@components)
    topLevelComp.render(@canvas.getContext('2d'), 1.0)

    @didRender(topLevelComp.weight)

module.exports = Compositor