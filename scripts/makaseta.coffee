# Description:
#   何かを任せますします
#
# Commands:
#   hubot <keywords>まかせた


module.exports = (robot) ->
  robot.respond /(.*)(まかせた|任命)/i, (msg) ->

    users = robot.brain.data.users
    user = users[Math.floor(Math.random() * users.length)]
    msg.send "#{msg.match[1]} @#{user.mention_name} にまかせた!"
