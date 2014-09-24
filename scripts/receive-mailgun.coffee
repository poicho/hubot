# Description:
#   Receive email from mailgun
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None

module.exports = (robot) ->

  robot.router.post "/mailgun/hook", (req, res) ->
    body = req.body
    message = """
    #{body.subject} from #{body.from}\n
    ```
    #{body['stripped-text']}
    """
    if body['stripped-signature'] && body['stripped-signature'].length > 0
      message += "\n#{body['stripped-signature']}"
    message += '\n```'
    robot.messageRoom '#mailbox', message
    res.end 'Thanks'
