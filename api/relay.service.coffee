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
      @_defer(=> mailbox.relay_count())

  getMessages: (mailbox)->
    @_defer(=> mailbox.getRelayMessages(@relay))

  deleteMessages: (mailbox, messagesToDelete = null)->
    if !messagesToDelete
      messagesToDelete = mailbox.relay_nonce_list()
    @_defer(=> mailbox.connectToRelay(@relay)).then =>
      @_defer(=> mailbox.relay_delete(messagesToDelete))

  # mailbox wrapper
  newMailbox: (mailboxName, options = {})=>
    return unless mailboxName
    # make our mailboxes
    if options.secret
      # secret = @CryptoService.nacl.crypto_box_keypair_from_raw_sk(atob(options.secret))
      # console.log secret
      # # console.log "b64", mailbox = new @CryptoService.Mailbox.fromSecKey(mailboxName, options.secret)
      # # console.log "decode b64", mailbox = new @CryptoService.Mailbox.fromSecKey(mailboxName, secret)
      # console.log "Code Array", mailbox = new @CryptoService.Mailbox.fromSecKey(secret, secret)
      # console.log "Code Array", mailbox = new @CryptoService.Mailbox.fromSecKey(mailboxName, secret.toCodeArray())
    else if options.seed
      mailbox = new @CryptoService.Mailbox.fromSeed(options.seed, mailboxName)
    else
      mailbox = new @CryptoService.Mailbox(mailboxName)

    # share keys among mailboxes
    for name, mbx of @mailboxes
      mbx.keyRing.addGuest(mailboxName, mailbox.getPubCommKey())
      mailbox.keyRing.addGuest(mbx.identity, mbx.getPubCommKey())

    # save the mailbox
    @mailboxes[mailboxName] = mailbox

  destroyMailbox: (mailbox)->
    for name, mbx of @mailboxes
      if mailbox.keyRing.storage.root == mbx.keyRing.storage.root
        mailbox.selfDestruct(true)
        delete @mailboxes[name]

  sendToVia: (recipient, mailbox, message)->
    deffered = @$q.defer()
    deffered.resolve mailbox.sendToVia(recipient, @relay, message)
    deffered.promise
  # internal stuffs

  # shortcut for converting .done to promise
  _defer: (fnToDefer)->
    deffered = @$q.defer()
    deffered.resolve fnToDefer()
    deffered.promise

  _newRelay: ->
    @relay = new @CryptoService.Relay(@host)
    @relay.client_token_text = @_randomString()

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
