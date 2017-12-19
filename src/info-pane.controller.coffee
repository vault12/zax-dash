class InfoPaneController
  constructor: ($scope, CryptoService)->
    $scope.relay_url = CryptoService.relayUrl()

angular
  .module 'app'
  .controller 'InfoPaneController', [
    '$scope'
    'CryptoService'
    InfoPaneController
  ]
