# Description:
#   何かを任せますします
#
# Commands:
#   hubot <keywords>まかせた

module.exports = (robot) ->
  robot.respond /(.*)(まかせた|任命)/i, (msg) ->

    users = robot.brain.data.users
    user_ids = Object.keys(users)
    if not user_ids.length > 0
      msg.send "しかし、ユーザーがいなかった！"
      return
    user = users[user_ids[Math.floor(Math.random() * user_ids.length)]]
    msg.send "#{msg.match[1]} #{user.name} にまかせた!"
