# This is an authentication proof-of-concept for hubot
# It uses a middleware pattern, which is already supported by hubot
# using the `robot.listenerMiddleware()` function.
# More information about it here: https://github.com/github/hubot/blob/master/docs/scripting.md#listener-middleware
# It assumes that a developer will *protect* his / her listeners that require
# integration authentication (token, credentials, etc.)
module.exports = (robot) ->

  # TODO: make all of these into their own pretty classes :)

  # TODO: integration registrar

  # the Vault library could be a npm package that wraps the HashiCorp API
  vault =
    getSecrets: (user, integration) ->
      # This is where you would make a secure (SSL/TLS) call to HashiCorp Vault
      "john:aReallySecurePassword"

  # The auth object will provide authentication convenience methods
  auth =
    authenticated: (user, integration)  ->
      # Uses Vault convenience methods
      secret = vault.getSecrets()
      robot.logger.info secret
      switch secret
        when ""
          return false
        else
          # FIXME: forcing it for now
          return false

  # IdentityPortal wrapper object
  # TODO: consider it to be encapsulated under robot.auth
  # TODO: identity portal should auto register to hubot via service discovery /
  identityPortal =
    # TODO: this would actually call the IdentityPortal (either via HTTP call or event message)
    generateTokenBasedUrl: () ->
      "http://identityportal/auth/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ"

  # Add auth middleware to HE
  # This middleware will run before any integration providing seamless auth
  # support for all hubot and /or HE calls.
  robot.listenerMiddleware (context, next, done) ->

    # The incoming message is passed in the context
    user = context.response.message.user.name
    msg = context.response.message.text

    # Log commands
    robot.logger.info "#{user} asked me to #{msg}"
    # robot.logger.info context.response.message

    # If integration command is protected, then run authenticated() check.
    if context.listener.options?.auth?.protected?

      integrationCommand = "myintegration somecommand"

      # Check if user is authenticated (has creds) for integration
      if secret = auth.authenticated(user,integrationCommand)
        robot.logger.info "#{context.response.message.user.name} authenticated :)"
        # Inject the secret in order to pass it to integrations.
        context.response.message.user.auth =
          secret: secret
        # Continue executing middleware
        next()
      else
        url = identityPortal.generateTokenBasedUrl()
        errMsg = "You are not authenticated, please do so via #{url}"
        robot.logger.info errMsg
        context.response.send errMsg
        done()

    else
      # Otherwise if integration command is not protected, continue next()
      robot.logger.info "Unprotected listener #{context.listener}"
      next()
