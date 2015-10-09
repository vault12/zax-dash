requestPane = (RequestService, LoggerService, base64)->
  directive =
    transclude: true
    restrict: 'E'
    templateUrl: "request-pane/request-pane.template.html"
    controller: "RequestPaneController"
    scope: "="
    link: (scope, attrs, element)->
      # What types of messages are possible. the fields array determines what fields the
      # user is presented for preparing a request.
      scope.commandType = [
        {name: "info", fields: []}
        {name: "count", fields: ["mailbox"]}
        {name: "upload", fields: ["mailbox", "message"]}
        {name: "download", fields: ["mailbox"]}
        {name: "delete", fields: ["mailbox", "message"]}
      ]

      scope.start = ->
        # console.log RequestService.session
        scope.session_info.started = true
        RequestService.startSession().then (response)->
          console.log response
          scope.session_info.client_token = scope.session.client_token_text
          scope.session_info.relay_token = base64.decode response

      scope.verify = ->
        scope.session_info.verified = true
        RequestService.verifySession().then (response)->
          console.log scope.session
          scope.session_info.public_key = "RequestService.session"

      scope.session = RequestService.session
      scope.session_info = {}

  directive

angular
  .module('app')
  .directive "requestPane", ['RequestService','LoggerService', 'base64', requestPane ]
