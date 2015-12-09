class RelayService
  host: ""
  headers: {"Content-Type": "text/plain"}
  mailboxes: {}

  constructor: (@$http, @$q, @CryptoService, $location) ->
    @host = @CryptoService.relayUrl()
    @_newRelay()

  # relay commands
  messageCount: (mailbox)->
    @_defer(=> mailbox.connectToRelay(@relay)).then =>
      @_defer(=> mailbox.relayCount())

  getMessages: (mailbox)->
    @_defer(=> mailbox.getRelayMessages(@relay))

  deleteMessages: (mailbox, messagesToDelete = null)->
    if !messagesToDelete
      messagesToDelete = mailbox.relayNonceList()
    @_defer(=> mailbox.connectToRelay(@relay)).then =>
      @_defer(=> mailbox.relayDelete(messagesToDelete))

  # mailbox wrapper
  newMailbox: (mailboxName = "", options = {})=>
    # make our mailboxes
    if options.secret
      mailbox = new @CryptoService.Mailbox.fromSecKey(options.secret.fromBase64(),mailboxName)
      console.log "created mailbox #{mailboxName}:#{options.secret} from secret"
    else if options.seed
      mailbox = new @CryptoService.Mailbox.fromSeed(options.seed, mailboxName)
      console.log "created mailbox #{mailboxName}:#{options.seed} from seed"
    else
      mailbox = new @CryptoService.Mailbox(mailboxName)
      console.log "created mailbox #{mailboxName} from scratch"


    # share keys among mailboxes
    for name, mbx of @mailboxes
      mbx.keyRing.addGuest(mailbox.identity, mailbox.getPubCommKey())
      mailbox.keyRing.addGuest(mbx.identity, mbx.getPubCommKey())

    # save the mailbox
    @mailboxes[mailbox.identity] = mailbox if mailbox.identity

  destroyMailbox: (mailbox)->
    for name, mbx of @mailboxes
      if mailbox.keyRing.storage.root == mbx.keyRing.storage.root
        mailbox.selfDestruct(true)
        delete @mailboxes[name]

  sendToVia: (recipient, mailbox, message)->
    @_defer(=> mailbox.sendToVia(recipient, @relay, message))

  # shortcut for converting .done to promise
  _defer: (fnToDefer)->
    deffered = @$q.defer()
    deffered.resolve fnToDefer()
    deffered.promise

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
