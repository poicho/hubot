# Description:
#   Qiita:Team
#
# Configuration:
#   HUBOT_QIITA_ACCESS_TOKEN
#   HUBOT_QIITA_TEAM_ID
#
# Commands:
#   hubot qiita ds - clone DS item from last created one
#
# Author:
#   gabu

Qiita = require 'qiita-js'
Qiita.setToken process.env.HUBOT_QIITA_ACCESS_TOKEN
Qiita.setEndpoint "https://#{process.env.HUBOT_QIITA_TEAM_ID}.qiita.com/"

moment = require('moment')

module.exports = (robot) ->
  robot.respond /qiita ds/i, (msg) ->
    cloneDS(msg)

cloneDS = (msg) ->
  Qiita.Resources.Item.list_tag_items('DS')
    .then (items) ->
      Qiita.Resources.Item.create_item({
        title: moment().format('YYYY/MM/DD ddd'),
        body: items[0].body,
        tags: [{name: 'DS'}],
        coediting: true
      })
        .then (item) ->
          msg.send "今日のDS #{item.url}"
        .catch (e) ->
          msg.send 'failed create_item'
    .catch (e) ->
      msg.send 'failed list_tag_items'
