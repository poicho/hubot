# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   hubot ping - 応答します
#   hubot echo <text> - オウム返しします
#   hubot time - 今の時間を教えます

module.exports = (robot) ->
  robot.respond /PING$/i, (msg) ->
    msg.send "PONG"

  robot.respond /ECHO (.*)$/i, (msg) ->
    msg.send msg.match[1]

  robot.respond /TIME$/i, (msg) ->
    msg.send "Server time is: #{new Date()}"

