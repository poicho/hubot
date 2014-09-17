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
    #{body.from}さんからのメール\n
    --------------------------------\n
    タイトル: "#{body.subject}"\n\n
    ```
    #{body['stripped-text']}\n\n
    #{body['stripped-signature']}
    ```
    """
    res.messageRoom '#mailbox', message
    res.end 'Thanks'
