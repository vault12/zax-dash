infoPane = ($compile)->
  directive =
    transclude: true
    restrict: 'E'
    templateUrl: "info-pane/info-pane.template.html"
    link: (scope, attrs, element)->
      scope.text = "asdf"

  directive

angular
  .module('app')
  .directive "infoPane", infoPane
