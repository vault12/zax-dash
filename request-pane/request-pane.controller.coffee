class RequestPaneController
  mailboxPrefix: "_mailbox"
  constructor: (RelayService, $scope)->
    # some names to play with
    first_names = ["Alice","Bob","Charlie","Chuck","Dave","Erin","Eve","Faith",
             "Frank","Mallory","Oscar","Peggy","Pat","Sam","Sally","Sybil",
             "Trent","Trudy","Victor","Walter","Wendy"].sort ->
               .5 - Math.random()
    @names = []
    for i in [1..20]
      for name in first_names
        if i == 1
          @names.push "#{name}"
        else
          @names.push "#{name} #{i}"


    # what mailboxes are we looking at?
    $scope.mailboxes = RelayService.mailboxes
    $scope.relay = RelayService.relay
    $scope.activeMailbox = null

    # assume we'll need to add a mailbox to play with
    $scope.mailbox = {}
    $scope.addMailboxVisible = true
    $scope.quantity = 3

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
          unless mailbox.messagesNonces.indexOf(msg.nonce) != -1
            console.log "incoming message:", msg
            mailbox.messagesNonces.push msg.nonce
            mailbox.messages.push msg

    $scope.deleteMessages = (mailbox, messagesToDelete = [])->
      RelayService.deleteMessages(mailbox, messagesToDelete).then ->
        if messagesToDelete.length == 0
          mailbox.messages = []
          mailbox.messagesNonces = []
        else
          for msg in messagesToDelete
            index = mailbox.messagesNonces.indexOf(msg)
            mailbox.messagesNonces.splice(index, 1)
            mailbox.messages.splice(index, 1)

    $scope.sendMessage = (mailbox, outgoing)=>
      RelayService.sendToVia(outgoing.recipient, mailbox, outgoing.message).then (data)->
        $scope.outgoing = {message: "", recipient: ""}

    $scope.deleteMailbox = (mailbox)=>
      name = mailbox.identity
      RelayService.destroyMailbox(mailbox)
      localStorage.removeItem "#{@mailboxPrefix}.#{name}"

    # show the active mailbox messages
    $scope.selectMailbox = (mailbox)->
      $scope.activeMailbox = mailbox

    # internals
    $scope.addMailbox = (name, options)=>
      if localStorage.setItem "#{@mailboxPrefix}.#{name}", RelayService.newMailbox(name, options).identity
        $scope.newMailbox = {name: "", options: null}

    $scope.addMailboxes = (quantityToAdd)=>
      for i in [1..quantityToAdd]
        $scope.addMailbox @names[1]
        @names.splice 0,1
      quantityToAdd = 0

    $scope.addPublicKey = (mailbox, key)=>
      if mailbox.keyRing.addGuest key.name, key.key
        $scope.pubKey = {name: "", key: ""}

    # add any mailbox stored in localStorage
    for key in Object.keys localStorage
      $scope.addMailbox(localStorage.getItem(key)) if key.indexOf(@mailboxPrefix) == 0

angular
  .module 'app'
  .controller 'RequestPaneController', [
    "RelayService"
    "$scope"
    RequestPaneController
  ]
