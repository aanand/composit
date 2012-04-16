Flickr = require('flickr')
Composition = require('composition')

exports.start = ->
  spinner = new Spinner()
  canvas  = $('canvas.render')[0]

  $('.search').submit (event) ->
    event.preventDefault()
    spinner.spin($(this).find(".spinner")[0])

    query = $(this).find('*[name=query]').val()
    composition = new Composition(canvas, 500, 500)

    composition.didRender = (numImages) ->
      $('.info').text("#{numImages} images composited.")

    Flickr.search query, (imageUrls) ->
      composition.addImageUrls(imageUrls)
      spinner.stop()