class CryptoService

  # You can provide your localhost:port value instead of test
  # to test local ZAX dashboard with local ZAX relay.
  # Take care not to mix up ports of these services when
  # both are running locally
  relayUrl: ->
    # Comment this out to use alternative relay url
    return @$window.location.origin

    # Uncomment below if you prefer to always connect to external relay
    # from your local build
    #
    # org = @$window.location.origin
    # # Configure your relay address. Likely 'http://localhost:8080' for local
    # relay = 'https://zax-test.vault12.com'
    # return if org.includes 'localhost' then relay else org

  constructor: ($http, @$window)->
    @glow = @$window.glow
    @nacl = @$window.nacl_factory.instantiate( -> )
    @Mailbox = @glow.MailBox
    @Relay = @glow.Relay
    @glow.CryptoStorage.startStorageSystem new @glow.SimpleStorageDriver(@relayUrl())

    @glow.Utils.setAjaxImpl (url, data)->
      $http(
        url: url
        method: 'POST'
        headers:
          'Accept': 'text/plain'
          'Content-Type': 'text/plain'
        data: data
        timeout: 2000
      ).then (response)->
        response.data

angular
  .module 'app'
  .service 'CryptoService', [
    '$http'
    '$window'
    CryptoService
  ]
