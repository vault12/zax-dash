requestPane = (RequestService, LoggerService, base64)->
  directive =
    transclude: true
    restrict: 'E'
    templateUrl: "request-pane/request-pane.template.html"
    controller: "RequestPaneController"
    scope: "="
    link: (scope, attrs, element)->

  directive

angular
  .module('app')
  .directive "requestPane", [ requestPane ]
