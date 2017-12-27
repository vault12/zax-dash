class InfoPaneController
  constructor: ($scope, RelayService)->
    $scope.relay_url = RelayService.relayUrl()
    $scope.editing_url = $scope.relay_url

    $scope.updateRelay = ->
      $scope.relay_url = $scope.editing_url
      $scope.editing = false

angular
  .module 'app'
  .controller 'InfoPaneController', [
    '$scope'
    'RelayService'
    InfoPaneController
  ]
