# Sample integration listeners that showcase how to protect
# a listener with the authenticaiton service.

module.exports = (robot) ->


  # To register a listener as an authenticated listener just use
  # the opts / metadata argument. If nothing is passed, then it is not protected.

  # TODO: (1) Integrations must register in their code to HE
  # (2) There should be a process of ensuring trust for a particular integration
  #     accomplished by using some form of code signing (we could investigate using
  #     Notary or some other code signing technique). We could be the CA.
  #     This could be enforced in a HE production environment and disabled during development (for scripts and integrations)

  # TODO: This mechanism is easily expanded also for authorization of users to a particular
  # integration command.

  robot.respond /myintegration foo/, he: { auth: { protected: true } }, (res) ->
      # robot.logger.info res
      res.send "You are authenticated!"

  robot.respond /myintegration bar/, (res) ->
      # robot.logger.info res
      res.send "unprotected"
