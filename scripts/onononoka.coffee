# Description:
#   Find おのののか images
#
# Commands:
#   hubot おのののか - おのののかを君に

module.exports = (robot) ->
  robot.respond /おのののか|nonoka/i, (msg) ->
    onoMe msg, (url) ->
      msg.send url

onoMe = (msg, cb) ->
  q = v: '1.0', rsz: 1, start: Math.floor(Math.random() * 100), q: "おのののか", safe: 'off', imgtype: 'photo'
  msg.http('http://ajax.googleapis.com/ajax/services/search/images')
    .query(q)
    .get() (err, res, body) ->
      images = JSON.parse(body)
      images = images.responseData?.results
      if images?.length > 0
        image  = msg.random images
        cb "#{image.unescapedUrl}#.png"
