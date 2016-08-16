# Robot = require("../node_modules/hubot/src/robot")
myhubot = require("hubot")
_ = require("lodash")

# A strictly inheritance approach would require to replace the instantiation of
# hubot robot with EnterpriseRobot. We would need to modify hubot package to accomplish this.
# Although it is possible, it is not recommended right now.
# Instead use method below:
# class EnterpriseRobot extends myhubot.Robot
#
#   respond: (regex, options, callback) ->
#     console.log "Hello respond"
#     super(regex, options, callback)

module.exports = (robot) ->

  # Using prototypal inheritance, we could override the class method for all
  # robots with new hear, listen, etc. methods that need Enterprise functionality
  # That way we can intercept listeners and register them accordingly to hubot Enterprise
  # Then we can override the processListener() function as well to perform a more
  # robust execution loop for listeners. All of this could be done backward compatible to
  # other scripts.
  # Reference: https://github.com/github/hubot/blob/0f37b55d7abc9bceee02c85383f480b5b00e015b/src/robot.coffee#L312

  myhubot.Robot::hear = (regex, options, callback) ->
    console.log("modified hear")

    if options.he
      console.log("Registering enterprise hear() listener")
      # TODO: in here, add the listener to a Listener Registrar for Enterprise

    # TODO: make this an if else, and fall back to the usual array of listeners
    @listeners.push new myhubot.TextListener(@, regex, options, callback)

  myhubot.Robot::listen = (matcher, options, callback) ->
    console.log("Modified listen")

    if options.he
        # TODO: in here, add the listener to a Listener Registrar for Enterprise
        console.log("Registering enterprise listen() listener")

    # TODO: make this an if else, and fall back to the usual array of listeners
    @listeners.push new myhubot.TextListener(@, regex, options, callback)

  # TODO: consider overriding respond(), however it calls hear() within it, so it might not be needed.

  # TODO: override processListener()
