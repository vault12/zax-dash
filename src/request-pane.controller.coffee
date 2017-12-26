class RequestPaneController
  mailboxPrefix: "_mailbox"
  constructor: (RelayService, $scope, $q, $timeout)->
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

    $scope.subscreen = 'inbox'

    # what mailboxes are we looking at?
    $scope.mailboxes = RelayService.mailboxes
    $scope.activeMailbox = null

    # assume we'll need to add a mailbox to play with
    $scope.mailbox = {}
    $scope.addMailboxVisible = true
    $scope.quantity = 3

    # mailbox commands
    $scope.messageCount = (mailbox)->
      RelayService.messageCount(mailbox).then ->
        $scope.$apply()

    $scope.getMessages = (mailbox)->
      RelayService.getMessages(mailbox).then (data)->
        if !mailbox.messages
          mailbox.messages = []
          mailbox.messagesNonces = []
        for msg in data
          unless mailbox.messagesNonces.indexOf(msg.nonce) != -1
            console.log "incoming message:", msg
            if msg.kind == 'file'
              msg.data = '📎 uploadID: ' + JSON.parse(msg.data).uploadID
            mailbox.messagesNonces.push msg.nonce
            mailbox.messages.push msg
        $scope.$apply()

    $scope.deleteMessages = (mailbox, messagesToDelete = null)->
      noncesToDelete = messagesToDelete or mailbox.messagesNonces or []
      RelayService.deleteMessages(mailbox, noncesToDelete).then ->
        if noncesToDelete.length == 0
          mailbox.messages = []
          mailbox.messagesNonces = []
        else
          for msg in noncesToDelete
            index = mailbox.messagesNonces.indexOf(msg)
            mailbox.messagesNonces.splice(index, 1)
            mailbox.messages.splice(index, 1)
        $scope.$apply()

    $scope.sendMessage = (mailbox, outgoing)->
      RelayService.sendToVia(outgoing.recipient, mailbox, outgoing.message).then (data)->
        $scope.messageSent = true
        $timeout(->
          $scope.messageSent = false
          $scope.$apply()
        , 3000)
        $scope.outgoing = {message: "", recipient: ""}
        $scope.$apply()

    $scope.deleteMailbox = (mailbox)=>
      name = mailbox.identity
      RelayService.destroyMailbox(mailbox).then =>
        localStorage.removeItem "#{@mailboxPrefix}.#{name}"

    # show the active mailbox messages
    $scope.selectMailbox = (mailbox)->
      $scope.activeMailbox = mailbox

    # internals
    $scope.addMailbox = (name, options)=>
      RelayService.newMailbox(name, options).then (mailbox)=>
        localStorage.setItem "#{@mailboxPrefix}.#{name}", mailbox.identity
        $scope.newMailbox = mailbox # {name: "", options: null}

    $scope.addMailboxes = (quantityToAdd)=>
      [1..quantityToAdd].reduce ((prev, i)=> prev.then => $scope.addMailbox @names.shift()), $q.all()

    $scope.refreshCounter = ->
      total = Object.keys $scope.mailboxes
      [0..total.length-1].reduce ((prev, i)=> prev.then => $scope.messageCount $scope.mailboxes[total[i]]), $q.all()

    $scope.addPublicKey = (mailbox, key)->
      if mailbox.keyRing.addGuest key.name, key.key
        $scope.keyAdded = true
        $timeout(->
          $scope.keyAdded = false
          $scope.$apply()
        , 3000)
        $scope.pubKey = {name: "", key: ""}
        $scope.$apply()

    # add any mailbox stored in localStorage
    next = $q.all()
    for key in Object.keys localStorage
      if key.indexOf(@mailboxPrefix) == 0
        ((key)->
          next = next.then -> $scope.addMailbox(localStorage.getItem(key))
        )(key)
    next

angular
  .module 'app'
  .controller 'RequestPaneController', [
    'RelayService'
    '$scope'
    '$q'
    '$timeout'
    RequestPaneController
  ]
