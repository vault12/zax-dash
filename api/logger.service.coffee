class LoggerService
  logEntries: []

  constructor: ($window, @$rootScope)->

  log: (eventObject, useConsole = false)->
    useConsole and console.log eventObject
    eventObject.time = Date.now()
    eventObject.type = eventObject.method or eventObject.status
    if @logEntries.push eventObject
      @$rootScope.$emit 'newLogEntry', eventObject

  all: ->
    @logEntries

angular
  .module 'app'
  .service 'LoggerService', [
    '$window'
    '$rootScope'
    LoggerService
  ]


# lets intercept and log all requests/responses

angular
  .module 'app'
  .config ($httpProvider)->
    $httpProvider.interceptors.push (LoggerService)->
      request: (req)->
        return req unless req.method == "POST"
        LoggerService.log req, false
        req
      response: (res)->
        return res unless res.config.method == "POST"
        LoggerService.log res, false
        res
