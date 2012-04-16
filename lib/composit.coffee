Flickr      = require('flickr')
ImageLoader = require('image-loader')
Compositor  = require('compositor')

exports.start = ->
  spinner   = new Spinner()
  spinnerEl = $(".spinner")[0]
  spinner.spin(spinnerEl)

  imageLoader = null

  canvas = $('.render canvas')[0]

  $('.search').submit (event) ->
    event.preventDefault()

    spinner.spin(spinnerEl)
    $('.render').fadeIn()

    canvas.width  = $('.render').width()
    canvas.height = canvas.width

    query = $(this).find('*[name=query]').val()

    compositor = new Compositor(canvas)

    compositor.onRender = (numImages) ->
      $('.info').show()
      $('.num-images').text("#{numImages} image#{if numImages != 1 then 's' else ''}")

    imageLoader.stop() if imageLoader
    imageLoader = new ImageLoader(compositor)

    imageLoader.onLoadFirstImage = ->
      spinner.stop()

    imageLoader.onLoadImage = (image) ->
      compositor.addImage(image)

    Flickr.search query, (imageUrls) ->
      imageLoader.addImageUrls(imageUrls)
