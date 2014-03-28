# Description:
#   Generate Faker String
#
# Commands:
#   hubot faker

Faker = require('Faker')

module.exports = (robot)->
  robot.respond /faker|ダミー|人/i, (msg)->
    msg.send """
      お探しの方はこちらですか？
      名前: #{ Faker.Name.findName() }
      メール: #{ Faker.Internet.email() }
      イメージ: #{ Faker.Image.avatar() }#.png
    """
