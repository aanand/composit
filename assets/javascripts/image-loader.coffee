class ImageLoader
  constructor: ->
    @firstImageLoaded = false
    @unloadedImages = {}

  addImageUrls: (imageUrls) ->
    imageUrls.forEach (url) =>
      image = new Image
      image.src = url

      @unloadedImages[image.src] = image

      image.onload = =>
        return if @stopped

        unless @firstImageLoaded
          @onLoadFirstImage(image) if @onLoadFirstImage
          @firstImageLoaded = true

        @onLoadImage(image) if @onLoadImage

        delete @unloadedImages[image.src]

  stop: ->
    @stopped = true

    for src, image of @unloadedImages
      image.src = ''
      delete @unloadedImages[src]

module.exports = ImageLoader