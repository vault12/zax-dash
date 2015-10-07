class RequestService
  host: ""

  constructor: (@$https, @LoggerService, @CryptoService, $location)->
    @host = $location.host()

  logRequest: (transaction_id, request)->
    @transactions[transaction_id] = request: request

  logResponse: (transaction_id, response)->
    @transactions[transaction_id] = response: response

  all: ->
    @transactions

angular
  .module 'app'
  .service 'RequestService', [
    '$https'
    'LoggerService'
    'CryptoService'
    '$location'
    RequestService
  ]
