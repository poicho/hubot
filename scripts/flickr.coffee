# Description:
#   Find flickr images
#
# Commands:
#   hubot flickr keyword - search from frickr

module.exports = (robot) ->
  robot.respond /flickr( me)? (.*)/i, (msg) ->
    flickrSearch msg, msg.match[2], (url) ->
      msg.send url

flickrSearch = (msg, keyword, cb) ->
  q = {
    method: 'flickr.photos.search',
    api_key: '320600df9410d923791142f6663af9c2',
    text: keyword,
    format: 'json',
    extras: 'url_m',
    per_page: 10,
    nojsoncallback: 1
  }
  msg.http('https://api.flickr.com/services/rest')
    .query(q)
    .get() (err, res, body) ->
      json = JSON.parse body
      photos = json.photos?.photo
      if photos?.length > 0
        photo = msg.random photos
        cb photo.url_m
