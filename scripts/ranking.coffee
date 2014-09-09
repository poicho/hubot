# Description:
#   先週のClipのチャンネルのView数のランキングを教えてくれます
#
# Commands:
#   hubot ランキング教えて - 先週のランキングを教えてくれます
#

module.exports = (robot) ->
  robot.respond /(.*)ランキング(教えて|おしえて)$/i, (msg) ->
    getRanking msg

getRanking = (msg) ->
  curr = new Date

  start = new Date
  start.setDate(curr.getDate() - curr.getDay() - 7)

  end = new Date
  end.setDate(curr.getDate() - curr.getDay())

  msg.send '了解しました！'
  msg.send "#{start.getMonth() + 1}/#{start.getDate()}から#{end.getMonth() + 1}/#{end.getDate()}のランキングを集計しています( ･`ω･´)"

  login msg, (token) ->
    msg.http("#{process.env.HUBOT_CLIP_ADMIN_RANKING}")
      .query(
        uuid: 'uuid'
        token: token
        start: "#{start.getTime() / 1000}"
        end: "#{end.getTime() / 1000}"
      )
      .get() (err, res, body) ->
        msg.send '先週のチャンネルランキング発表!'
        json = JSON.parse(body)
        for channel, i in json
          msg.send "#{i + 1}位: #{channel.title}(#{channel.channel_slug}, #{channel.view_count} views)"

login = (msg, cb) ->
  msg.http("#{process.env.HUBOT_CLIP_LOGIN}")
    .header('Content-Type', 'application/x-www-form-urlencoded')
    .post("email=#{process.env.HUBOT_RANKING_USER_EMAIL}&password=#{process.env.HUBOT_RANKING_USER_PASS}&method=email&uuid=uuid") (err, res, body) ->
      json = JSON.parse(body)
      cb json.token?.token




