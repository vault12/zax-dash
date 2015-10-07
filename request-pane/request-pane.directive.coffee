
requestPane = ($compile)->
  directive =
    transclude: true
    restrict: 'E'
    templateUrl: "request-pane/request-pane.template.html"
    controller: "RequestPaneController"
    scope: "="
    link: (scope, attrs, element)->
      scope.requestTypes = [
        {name: "Add Mailbox", active: true}
        {name: "Remove Mailbox"}
        {name: "Add Message"}
        {name: "Remove Message"}
        {name: "Info"}
      ]

  directive

angular
  .module('app')
  .directive "requestPane", requestPane
