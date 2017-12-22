class InfoPaneController
  constructor: ($scope, CryptoService, RelayService)->
    $scope.relay_url = CryptoService.relayUrl()
    $scope.editing_url = $scope.relay_url

    $scope.updateRelay = ->
      $scope.relay_url = $scope.editing_url
      $scope.editing = false

angular
  .module 'app'
  .controller 'InfoPaneController', [
    '$scope'
    'CryptoService'
    'RelayService'
    InfoPaneController
  ]
