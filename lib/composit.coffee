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
    query = $(this).find('*[name=query]').val()
    window.history.pushState(null, null, '?q=' + window.escape(query))
    doSearch(query)

  doSearch = (query) ->
    spinner.spin(spinnerEl)
    $('.render, .info').fadeIn()
    $('.num-images').html('&nbsp;')

    canvas.width  = $('.render').width()
    canvas.height = canvas.width

    compositor = new Compositor(canvas)

    compositor.onRender = (numImages) ->
      $('.num-images').text("#{numImages} image#{if numImages != 1 then 's' else ''}")

    imageLoader.stop() if imageLoader
    imageLoader = new ImageLoader(compositor)

    imageLoader.onLoadFirstImage = ->
      spinner.stop()

    imageLoader.onLoadImage = (image) ->
      compositor.addImage(image)

    Flickr.search query, (imageUrls) ->
      imageLoader.addImageUrls(imageUrls)

  doSearchFromQueryString = ->
    params = Object.fromQueryString(window.location.search)
    query = params.q

    if query
      query = query.replace(/\+/g, ' ') # thanks, sugar.js
      $('*[name=query]').val(query)
      doSearch(query)

  popped     = window.history.state?
  initialURL = window.location.href

  window.addEventListener 'popstate', (event) ->
    initialPop = !popped && (window.location.href == initialURL)
    return if initialPop
    doSearchFromQueryString()

  doSearchFromQueryString()