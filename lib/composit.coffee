exports.start = ->
  $('.search').submit (event) ->
    event.preventDefault()

    query = $(this).find('*[name=query]').val()

    url = 'http://api.flickr.com/services/rest/?jsoncallback=?'
    params =
      api_key: 'bb0cc7a9132fab50731b647bc0c1cbe4'
      format: 'json'
      method: 'flickr.photos.search'
      media: 'photos'
      text: query

    $.getJSON url, params, (data) ->
      images = $('.images').empty()

      for photo in data.photos.photo
        imageUrl = "http://farm#{photo.farm}.staticflickr.com/#{photo.server}/#{photo.id}_#{photo.secret}.jpg"
        $('<img/>').attr('src', imageUrl).appendTo(images)
