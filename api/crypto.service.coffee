class CryptoService

  constructor: ($window)->
    @glow = $window.glow
    @nacl = $window.nacl_factory.instantiate()

angular
  .module 'app'
  .service 'CryptoService', [
    '$window'
    CryptoService
  ]
