# Description:
#   Hubot answers your question
#
# Configration:
#   HUBOT_GOOGLE_SEARCH_KEY
#   HUBOT_GOOGLE_SEARCH_CX
#
# Notes:
#   Hubot replys with 〇〇とは?
#
# Author:
#   fly1tkg

module.exports = (robot) ->
  robot.hear /(.*)とは(\?|？)/, (msg) ->
    msg.http('https://www.googleapis.com/customsearch/v1')
      .query
        key: process.env.HUBOT_GOOGLE_SEARCH_KEY
        cx: process.env.HUBOT_GOOGLE_SEARCH_CX
        q: msg.match[1]
        num: 3
      .get() (err, res, body) ->
        resp = msg.match[1] + 'とは\n'
        results = JSON.parse(body)
        if !err && results.items
          results.items.forEach (item) ->
            resp += item.title + ' - ' + item.link + '\n'
          msg.send resp





