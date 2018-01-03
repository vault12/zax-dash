angular
  .module('app')
  .directive 'dashboard', ->
    {
      replace: true
      restrict: 'E'
      templateUrl: 'src/dashboard.template.html'
      controller: 'DashboardController'
      scope: '='
    }