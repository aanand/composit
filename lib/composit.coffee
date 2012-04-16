Flickr = require('flickr')
Compositor = require('compositor')

exports.start = ->
  $('.render, .info').hide()

  spinner = new Spinner()
  spinner.spin($(".spinner")[0])

  canvas = $('.render canvas')[0]

  $('.search').submit (event) ->
    event.preventDefault()

    $('.render').fadeIn()
    canvas.width = $('.render').width()
    canvas.height = canvas.width

    query = $(this).find('*[name=query]').val()
    compositor = new Compositor(canvas)

    compositor.didRender = (numImages) ->
      $('.info').show()
      $('.num-images').text("#{numImages}")

    Flickr.search query, (imageUrls) ->
      compositor.addImageUrls(imageUrls)
      spinner.stop()