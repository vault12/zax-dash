angular
  .module('app')
  .directive 'requestPane', ->
    {
      replace: true
      restrict: 'E'
      templateUrl: 'src/request-pane.template.html'
      controller: 'RequestPaneController'
      scope: '='
    }