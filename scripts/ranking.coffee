# Description:
#   先週のClipのチャンネルのView数のランキングを教えてくれます
#
# Configuration:
#   HUBOT_CLIP_ADMIN_RANKING
#   HUBOT_CLIP_LOGIN
#   HUBOT_RANKING_USER_EMAIL
#   HUBOT_RANKING_USER_PASS
#   HUBOT_MAIL_SENDER_USER
#   HUBOT_RANKING_MAIL_TO
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

  term_s = "#{start.getMonth() + 1}/#{start.getDate()}から#{end.getMonth() + 1}/#{end.getDate()}"

  msg.send '了解しました！'
  msg.send "#{term_s}のランキングを集計しています( ･`ω･´)"

  login msg, (token) ->
    msg.http("#{process.env.HUBOT_CLIP_ADMIN_RANKING}")
      .query(
        uuid: 'uuid'
        token: token
        start: "#{start.getTime() / 1000}"
        end: "#{end.getTime() / 1000}"
      )
      .get() (err, res, body) ->
        json = JSON.parse(body)

        ranking_msg = "#{term_s}のチャンネルランキング発表!\n"

        for channel, i in json
          ranking_msg += "#{i + 1}位: #{channel.title}(#{channel.channel_slug}, #{channel.view_count} views)\n"

        msg.send ranking_msg

        sendMail msg, "#{term_s}のランキング", ranking_msg

login = (msg, cb) ->
  msg.http("#{process.env.HUBOT_CLIP_LOGIN}")
    .header('Content-Type', 'application/x-www-form-urlencoded')
    .post("email=#{process.env.HUBOT_RANKING_USER_EMAIL}&password=#{process.env.HUBOT_RANKING_USER_PASS}&method=email&uuid=uuid") (err, res, body) ->
      json = JSON.parse(body)
      cb json.token?.token


mailer = require('nodemailer')
transporter = mailer.createTransport({
  service: 'Gmail',
  auth: {
    user: process.env.HUBOT_MAIL_SENDER_USER,
    pass: process.env.HUBOT_MAIL_SENDER_PASS
  }
})

sendMail = (msg, subject, body) ->
  options = {
    from: "Hubot <#{process.env.HUBOT_MAIL_SENDER_USER}>",
    to : process.env.HUBOT_RANKING_MAIL_TO,
    subject: subject,
    text: body
  }
  transporter.sendMail options, (err, info) ->
    if not err
      msg.send 'ランキングをメールしました'

