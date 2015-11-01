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
      RelayService.getMessages(mailbox).then (data)->
        if !mailbox.messages
          mailbox.messages = []
          mailbox.messagesNonces = []
        for msg in mailbox.lastDownload
          console.log data
          if mailbox.messagesNonces.indexOf msg.nonce == -1
            mailbox.messagesNonces.push msg.nonce
            mailbox.messages.push msg

    $scope.deleteMessages = (mailbox)->
      RelayService.deleteMessages(mailbox).then ->
        console.log "deleted messages."



    $scope.sendMessage = (recipient, mailbox)->
      message = mailbox.messageToSend
      RelayService.sendToVia(recipient, mailbox, {message}).then (data)->
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
