logPane = ($compile)->
  directive =
    transclude: true
    restrict: 'E'
    templateUrl: "log-pane/log-pane.template.html"
    controller: "LogPaneController"
    link: (scope, attrs, element)->
      scope.text = attrs.text or ""

  directive

angular
  .module('app')
  .directive "logPane", logPane
