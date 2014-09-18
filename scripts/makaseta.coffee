# Description:
#   今日の司会を任せます
#
# Commands:
#   hubot 今日の司会は<keywords>にまかせた

module.exports = (robot) ->
  robot.hear /(.*)(今日の司会)/i, (msg) ->

    users = robot.brain.data.users
    user_ids = Object.keys(users)
    if not user_ids.length > 0
      msg.send "しかし、ユーザーがいなかった！"
      return
    user = users[user_ids[Math.floor(Math.random() * user_ids.length)]]
    msg.send "今日の司会は #{msg.match[1]} #{user.name} にまかせた!"
