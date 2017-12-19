class InfoPaneController
  constructor: ($scope, CryptoService)->
    $scope.relay_url = CryptoService.relayUrl()

    $scope.updateRelay = ->
      $scope.editing = false

angular
  .module 'app'
  .controller 'InfoPaneController', [
    '$scope'
    'CryptoService'
    InfoPaneController
  ]
