class RequestPaneController
  mailboxes: {}
  constructor: (base64, RelayService, $scope)->
    # what mailboxes are we looking at?
    $scope.mailboxes = @mailboxes
    $scope.addMailbox = @addMailbox
    $scope.selectMailbox = @selectMailbox
    $scope.activeMailbox = null

    # assue we'll need to add a mailbox to play with
    $scope.mailbox = {}
    $scope.addMailboxVisible = true

    #command we're going to run on active mailbox
    $scope.changeActiveCommand = (command)->
      $scope.activeCommand = command

    $scope.changeActiveCommand "count"

    # actual communication
    $scope.createSession = ->
      RelayService.startSession().then (startResponse)->
        RelayService.verifySession().then (verifyResponse)->
        $scope.session_info.client_token = $scope.session.client_token_text
        $scope.session_info.relay_token = base64.decode startResponse
        $scope.sessionCreated = true

    $scope.connectMailbox = ->
      RelayService.connectMailbox($scope.activeMailbox).then (response)->
        $scope.activeMailbox.connected = true

    $scope.session = RelayService.session
    $scope.session_info = {}

    $scope.runCommand = ->
      RelayService.runCommand($scope.activeCommand, $scope.activeMailbox).then (response)->
        $scope.lastCommandResult = base64.decode response

    # internals
    $scope.addMailbox = ->
      name = $scope.mailbox.name
      box = RelayService.newMailbox(name)
      box.name = name
      @mailboxes[$scope.mailbox.name] = box
      $scope.mailbox = {}
      @selectMailbox box.name
      console.log @mailboxes

    # select a mailbox for use
    $scope.selectMailbox = (name)->
      $scope.activeMailbox = null
      return unless @mailboxes[name]
      $scope.activeMailbox = @mailboxes[name]
      $scope.addMailboxVisible = false



angular
  .module 'app'
  .controller 'RequestPaneController', [
    "base64"
    "RelayService"
    "$scope"
    RequestPaneController
  ]
