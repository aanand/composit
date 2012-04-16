Flickr      = require('flickr')
ImageLoader = require('image-loader')
Compositor  = require('compositor')

exports.start = ->
  $('.render, .info').hide()

  spinner   = new Spinner()
  spinnerEl = $(".spinner")[0]
  spinner.spin(spinnerEl)

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
      $('.num-images').text("#{numImages}")

    imageLoader = new ImageLoader(compositor)

    imageLoader.onLoadFirstImage = ->
      spinner.stop()

    imageLoader.onLoadImage = (image) ->
      compositor.addImage(image)

    Flickr.search query, (imageUrls) ->
      imageLoader.addImageUrls(imageUrls)
