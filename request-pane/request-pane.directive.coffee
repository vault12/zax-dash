angular
  .module('app')
  .directive 'requestPane', ->
    {
      replace: true
      restrict: 'E'
      templateUrl: 'request-pane/request-pane.template.html'
      controller: 'RequestPaneController'
      scope: '='
    }