class RelayService
  host: ""
  headers: {"Content-Type": "text/plain"}
  mailboxes: {}

  constructor: (@$http, @$q, @CryptoService, $location) ->
    @host = @CryptoService.relayUrl()
    @_newRelay()

  # relay commands
  messageCount: (mailbox)->
    mailbox.connectToRelay(@relay).then =>
      mailbox.relayCount(@relay).then (count)=>
        mailbox.messageCount = count
        count

  getMessages: (mailbox)->
    mailbox.getRelayMessages(@relay)

  deleteMessages: (mailbox, noncesToDelete)->
    mailbox.connectToRelay(@relay).then =>
      mailbox.relayDelete(noncesToDelete, @relay)

  # mailbox wrapper
  newMailbox: (mailboxName, options = {})=>
    # make our mailboxes
    next = null
    if options.secret
      mailboxName = @_randomString() if not mailboxName
      next = @CryptoService.Mailbox.fromSecKey(options.secret.fromBase64(), mailboxName).then (mailbox)=>
        console.log "created mailbox #{mailboxName}:#{options.secret} from secret"
        mailbox
    else if options.seed
      next = @CryptoService.Mailbox.fromSeed(options.seed, mailboxName).then (mailbox)=>
        console.log "created mailbox #{mailboxName}:#{options.seed} from seed"
        mailbox
    else
      next = @CryptoService.Mailbox.new(mailboxName).then (mailbox)=>
        console.log "created mailbox #{mailboxName} from scratch"
        mailbox

    next.then (mailbox)=>
      @messageCount(mailbox).then =>
        # share keys among mailboxes
        tasks = []
        for name, mbx of @mailboxes
          ((name, mbx)=>
            tasks.push mbx.keyRing.addGuest(mailbox.identity, mailbox.getPubCommKey()).then =>
              mailbox.keyRing.addGuest(mbx.identity, mbx.getPubCommKey())
          )(name, mbx)

        @$q.all(tasks).then =>
          # save the mailbox
          @mailboxes[mailbox.identity] = mailbox
          mailbox

  destroyMailbox: (mailbox)->
    tasks = []
    for name, mbx of @mailboxes
      if mailbox.keyRing.storage.root == mbx.keyRing.storage.root
        ((mailbox, name)=>
          tasks.push mailbox.selfDestruct(true).then =>
            console.log 'deleting ' + name
            delete @mailboxes[name]
        )(mailbox, name)
    @$q.all(tasks)

  sendToVia: (recipient, mailbox, message)->
    mailbox.sendToVia(recipient, @relay, message)

  _newRelay: ->
    @relay = new @CryptoService.Relay(@host)
    # @relay.client_token_text = @_randomString()

  _concat: (arrays...)->
    concatArray = []
    for array in arrays
      for item in array
        concatArray.push item
    concatArray

  _randomString: (length=32) ->
    id = ""
    id += Math.random().toString(36).substr(2) while id.length < length
    id.substr 0, length

angular
  .module 'app'
  .service 'RelayService', [
    '$http'
    '$q'
    'CryptoService'
    '$location'
    RelayService
  ]
