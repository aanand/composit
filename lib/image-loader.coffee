class ImageLoader
  constructor: (@receiver) ->
    @firstImageLoaded = false

  addImageUrls: (imageUrls) ->
    imageUrls.forEach (url) =>
      image = new Image
      image.src = url
      image.onload = =>
        @receiver.addImage(image)

        unless @firstImageLoaded
          @onLoadFirstImage()
          @firstImageLoaded = true

module.exports = ImageLoader