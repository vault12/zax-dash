class CryptoService

  # You can provide your localhost:port value instead of test
  # to test local ZAX dashboard with local ZAX relay.
  # Take care not to mix up ports of these services when
  # both are running locally
  relayUrl: ->
    org = @$window.location.origin
    test = 'https://zax_test.vault12.com'
    return if org.includes 'localhost' then test else org

  constructor: (@$window)->
    @glow = @$window.glow
    @nacl = @$window.nacl_factory.instantiate()
    @Mailbox = @glow.MailBox
    @Relay = @glow.Relay
    @KeyRing = @glow.KeyRing
    @Keys = @glow.Keys
    @CryptoStorage = @glow.CryptoStorage
    @CryptoStorage.startStorageSystem new @glow.SimpleStorageDriver(@relayUrl())

    # set the ajax handler. to jQuery
    @glow.Utils.setAjaxImpl (url, data)->
      $.ajax
        method: 'POST'
        url: url
        headers:
          'Accept': 'text/plain'
          'Content-Type': 'text/plain'
        data: data
        responseType: 'text'
        timeout: 2000
      .then (response)->
        response

angular
  .module 'app'
  .service 'CryptoService', [
    '$window'
    CryptoService
  ]
