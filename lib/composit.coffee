Flickr = require('flickr')
Compositor = require('compositor')

exports.start = ->
  spinner = new Spinner()
  canvas  = $('canvas.render')[0]

  $('.search').submit (event) ->
    event.preventDefault()
    spinner.spin($(this).find(".spinner")[0])

    query = $(this).find('*[name=query]').val()
    compositor = new Compositor(canvas, 500, 500)

    compositor.didRender = (numImages) ->
      $('.info').text("#{numImages} images composited.")

    Flickr.search query, (imageUrls) ->
      compositor.addImageUrls(imageUrls)
      spinner.stop()