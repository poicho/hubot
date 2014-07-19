module.exports = (robot) ->
  robot.hear /(.*)とは/, (msg) ->
    msg.http('https://www.googleapis.com/customsearch/v1')
      .query
        key: process.env.HUBOT_GOOGLE_SEARCH_KEY
        cx: process.env.HUBOT_GOOGLE_SEARCH_CX
        q: msg.match[1]
        num: 3
      .get() (err, res, body) ->
        resp = ''
        results = JSON.parse(body)
        if results.error
          results.error.errors.forEach (err) ->
            resp += err.message
        else
          results.items.forEach (item) ->
            resp += item.title + ' - ' + item.link + '\n'
        msg.send resp




