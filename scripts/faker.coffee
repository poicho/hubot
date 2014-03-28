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
      電話番号: #{ Faker.PhoneNumber.phoneNumber() }
      郵便番号: #{ Faker.Address.zipCode() }
      住所: #{ Faker.Address.streetName() } - #{ Faker.Address.streetAddress() }
      イメージ: #{ Faker.Image.avatar() }
    """
