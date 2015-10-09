logPane = ($rootScope, LoggerService)->
  directive =
    transclude: true
    restrict: 'E'
    templateUrl: "log-pane/log-pane.template.html"
    controller: "LogPaneController"
    link: (scope, attrs, element)->
      $rootScope.$on "newLogEntry", ->
        scope.logEntries = LoggerService.all()

  directive

angular
  .module('app')
  .directive "logPane", ['$rootScope', 'LoggerService', logPane]
