RelaySession = ->
  relaySession = (clientToken)->

    request=
      client_token: clientToken
      relay_token: ''





angular
  .module "app"
  .factory "RelaySession", RelaySession
