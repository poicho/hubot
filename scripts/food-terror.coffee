# Description:
#   Find 飯テロ images
#
# Commands:
#   hubot 飯テロ - ゲットカロリー

module.exports = (robot) ->
  robot.respond /(飯テロ|food|meshi|メシテロ|めしてろ)/i, (msg) ->
    foodTerror msg, (url) ->
      msg.send url

foodTerror = (msg, cb) ->
  words = ['焼肉', 'meat', '寿司', 'ピザ', 'pizza', 'ラーメン']
  q = v: '1.0', rsz: '8', q: words[Math.floor(Math.random() * words.length)], safe: 'moderate'
  msg.http('http://ajax.googleapis.com/ajax/services/search/images')
    .query(q)
    .get() (err, res, body) ->
      images = JSON.parse(body)
      images = images.responseData?.results
      if images?.length > 0
        image  = msg.random images
        cb "#{image.unescapedUrl}#.png"
