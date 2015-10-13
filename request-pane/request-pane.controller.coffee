class RequestPaneController
  mailboxes: {}
  constructor: (base64, RelayService, $scope)->
    # what mailboxes are we looking at?
    $scope.mailboxes = RelayService.mailboxes
    $scope.relay = RelayService.relay
    $scope.addMailbox = @addMailbox
    $scope.selectMailbox = @selectMailbox
    $scope.activeMailbox = null

    # assue we'll need to add a mailbox to play with
    $scope.mailbox = {}
    $scope.addMailboxVisible = true

    # mailbox commands
    $scope.messageCount = (mailbox)->
      RelayService.messageCount(mailbox).then (data)->
        mailbox.messageCount = "#{$scope.relay.result}"

    $scope.getMessages = (mailbox)->
      RelayService.getMessages(mailbox).then ->
        console.log mailbox.lastDownload

    $scope.sendMessage = (recipient, mailbox)->
      console.log recipient, mailbox, mailbox.messageToSend
      RelayService.sendToVia(recipient, mailbox, {message: mailbox.messageToSend}).then (data)->
        mailbox.messageToSend = ""

      then: (fn)->
        fn(3);

    $scope.deleteMailbox = (mailbox)->
      RelayService.destroyMailbox(mailbox)

    # internals
    $scope.addMailbox = (name, seed = null)->
      box = RelayService.newMailbox(name, seed)




angular
  .module 'app'
  .controller 'RequestPaneController', [
    "base64"
    "RelayService"
    "$scope"
    RequestPaneController
  ]
