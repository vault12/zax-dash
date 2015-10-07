

    class LoggerService
      transactions: {}

      constructor: ($window)->

      logRequest: (transaction_id, request)->
        @transactions[transaction_id] = request: request

      logResponse: (transaction_id, response)->
        @transactions[transaction_id] = response: response

      all: ->
        @transactions
        
    angular
      .module 'app'
      .service 'LoggerService', [
        '$window'
        LoggerService
      ]
