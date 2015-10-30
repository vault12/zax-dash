class CryptoService

  # You can provide your localhost:port value instead of test
  # to test local ZAX dashboard with local ZAX relay. 
  # Take care not to mix up ports of these services when
  # both are running locally
  relayUrl: ->
    org = window.location.origin
    test = 'http://zax_test.vault12.com'
    return if org.includes 'localhost' then test else org #$location.host()

  constructor: ($window, $http, $q)->
    @glow = $window.glow
    @nacl = $window.nacl_factory.instantiate()
    @Mailbox = @glow.MailBox
    @Relay = @glow.Relay
    @KeyRing = @glow.KeyRing
    @Keys = @glow.Keys
    @CryptoStorage = @glow.CryptoStorage
    console.log @relayUrl()
    @CryptoStorage.startStorageSystem new @glow.SimpleStorageDriver(@relayUrl())

    # switch the glow ajax fn to use angular.
    # @glow.Utils.ajax = (->
    #   (options = {})->
    #     options.url = options.url
    #     options.method = "POST"
    #     options.headers =
    #       "Content-Type": options.contentType or null
    #
    #     promise = $http(options)
    #     promise.done = (fn)->
    #       promise.then (response)->
    #         console.log options.context
    #         @_error_handler = options.error or false
    #         fn(response.data, "", "")
    #     promise
    #   )()

angular
  .module 'app'
  .service 'CryptoService', [
    '$window'
    '$http'
    '$q'
    CryptoService
  ]
