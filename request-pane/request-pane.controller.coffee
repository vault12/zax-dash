class RequestPaneController
  mailboxes: {}
  constructor: (base64, RelayService, $scope)->
    # some names to play with
    first_names = ["Alice","Bob","Charlie","Chuck","Dave","Erin","Eve","Faith",
             "Frank","Mallory","Oscar","Peggy","Pat","Sam","Sally","Sybil",
             "Trent","Trudy","Victor","Walter","Wendy"]
    @names = []
    for i in [2..50]
      @names.push "#{name}_#{i}" for name in first_names


    # what mailboxes are we looking at?
    $scope.mailboxes = RelayService.mailboxes
    $scope.relay = RelayService.relay

    $scope.activeMailbox = null

    # assume we'll need to add a mailbox to play with
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

    $scope.sendMessage = (mailbox, outgoing)->
      message = outgoing.message
      recipient = $scope.mailboxes[outgoing.recipient]

      RelayService.sendToVia(recipient, mailbox, {message}).then (data)->
        outgoing = {}

      # then: (fn)->
      #   fn(3);

    $scope.deleteMailbox = (mailbox)->
      RelayService.destroyMailbox(mailbox)

    # show the active mailbox messages
    $scope.selectMailbox = (mailbox)->
      $scope.activeMailbox = mailbox

    # internals
    $scope.addMailbox = (name, seed = null)->
      box = RelayService.newMailbox(name, seed)

    $scope.addMailboxes = (quantityToAdd)=>
      for i in [1..quantityToAdd]
        $scope.addMailbox @names[1], @names[1]
        @names.splice 0,1
      quantityToAdd = 0





angular
  .module 'app'
  .controller 'RequestPaneController', [
    "base64"
    "RelayService"
    "$scope"
    RequestPaneController
  ]
