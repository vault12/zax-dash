class RequestService
  host: ""
  headers: {"Content-Type": "text/plain"}


  constructor: (@$http,  @CryptoService, $location, @RelaySession, @base64)->
    @host = 'http://104.236.171.11' #$location.host()
    @newSession()

  startSession: ->
    action = @session.getServerToken()
    @session.client_token_text = @CryptoService.nacl.to_hex @session.client_token
    # @$http
    #   method: "POST"
    #   url: "http://#{@host}/start_session"
    #   data: @base64.encode @session.client_token_text
    #   headers: @headers
    action


  verifySession: ->
    @session.getServerKey()
    # window.util = "asdf"
    # h2_client_token = @base64.encode @CryptoService.nacl.encode_latin1 @CryptoService.glow.Nacl.h2(@session.client_token)
    # h2_verify_token = @base64.encode @CryptoService.nacl.encode_latin1 @CryptoService.glow.Nacl.h2(@session.client_token.concat @session.relay_token)
    # # get the original random string
    # relay_token = @base64.decode(relay_token_encoded)
    # #
    # # # convert to array
    # # client_token_array = @CryptoService.nacl.encode_latin1(client_token)
    # # relay_token_array = @CryptoService.nacl.encode_utf8(relay_token)
    #
    # # hash array
    # client_hashed_array = @_h2 client_token
    # verify_hashed_array = @_h2 "#{client_token}#{relay_token}"
    # console.log client_hashed_array, verify_hashed_array
    #
    # # # back to string, then base64
    # verify_string = @base64.encode verify_hashed_array
    # client_string = @base64.encode client_hashed_array

    #
    # @$http
    #   method: "POST"
    #   url: "http://#{@host}/verify_session"
    #   data: "#{h2_client_token}\r\n#{h2_verify_token}\r\n"
    #   headers: @headers

  newSession: ->
    @session = new @CryptoService.glow.Relay(@host)
    @session.client_token_text = @_randomString()

  _concat: (arrays...)->
    concatArray = []
    for array in arrays
      for item in array
        concatArray.push item
    concatArray

  _randomString: (length=32) ->
    id = ""
    id += Math.random().toString(36).substr(2) while id.length < length
    id.substr 0, length

angular
  .module 'app'
  .service 'RequestService', [
    '$http'
    'CryptoService'
    '$location'
    'RelaySession'
    'base64'
    RequestService
  ]
