class CryptoService

  constructor: ($window, $http, $q)->
    @glow = $window.glow
    @nacl = $window.nacl_factory.instantiate()
    @Mailbox = @glow.MailBox
    @Relay = @glow.Relay
    @KeyRing = @glow.KeyRing
    @Keys = @glow.Keys
    @CryptoStorage = @glow.CryptoStorage
    @CryptoStorage.startStorageSystem new @glow.TestDriver

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
