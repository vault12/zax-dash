
class LogPaneController
  contstructor: ()->
    console.log "success", 'logctrl'

angular
  .module 'app'
  .controller 'LogPaneController', [
    LogPaneController
  ]
