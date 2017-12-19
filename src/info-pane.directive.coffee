angular
  .module('app')
  .directive 'infoPane', ->
    {
      replace: true
      restrict: 'E'
      templateUrl: 'src/info-pane.template.html'
      controller: 'InfoPaneController'
      scope: '='
    }