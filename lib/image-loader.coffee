class ImageLoader
  constructor: ->
    @firstImageLoaded = false

  addImageUrls: (imageUrls) ->
    imageUrls.forEach (url) =>
      image = new Image
      image.src = url
      image.onload = =>
        unless @firstImageLoaded
          @onLoadFirstImage(image) if @onLoadFirstImage
          @firstImageLoaded = true

        @onLoadImage(image) if @onLoadImage

module.exports = ImageLoader