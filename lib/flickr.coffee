exports.search = (query, callback) ->
  url = 'http://api.flickr.com/services/rest/?jsoncallback=?'

  params =
    api_key: 'bb0cc7a9132fab50731b647bc0c1cbe4'
    format: 'json'
    method: 'flickr.photos.search'
    media: 'photos'
    text: query

  $.getJSON url, params, (data) ->
    photoUrls = data.photos.photo.map (p) -> "http://farm#{p.farm}.staticflickr.com/#{p.server}/#{p.id}_#{p.secret}.jpg"
    callback(photoUrls)