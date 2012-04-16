Flickr = require('flickr')

exports.start = ->
  spinner = new Spinner()

  $('.search').submit (event) ->
    event.preventDefault()
    spinner.spin($(this).find(".spinner")[0])

    query = $(this).find('*[name=query]').val()

    Flickr.search query, (images) ->
      $('.images').empty()

      images.each (imageUrl) ->
        $('<img/>').attr('src', imageUrl).appendTo('.images')

      spinner.stop()