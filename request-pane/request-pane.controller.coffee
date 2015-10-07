class RequestPaneController
  contstructor: (@$scope)->
    console.log "loaded", @$scope
    @$scope.changeMessageType = (messageType)->
      console.log messageType

angular
  .module 'app'
  .controller 'RequestPaneController', [
    "$scope"
    RequestPaneController
  ]
