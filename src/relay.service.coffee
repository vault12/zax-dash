class RelayService
  mailboxes: {}

  relayUrl: ->
    # Comment this out to use alternative relay url.
    # Take care not to mix up ports of these services when
    # both are running locally
    return 'https://zax-test.vault12.com' # @$window.location.origin

  constructor: (@$q, $http, @$window) ->
    @Mailbox = @$window.glow.MailBox
    @Relay = @$window.glow.Relay
    @$window.glow.CryptoStorage.startStorageSystem new @$window.glow.SimpleStorageDriver @relayUrl()

    @$window.glow.Utils.setAjaxImpl (url, data)->
      $http(
        url: url
        method: 'POST'
        headers:
          'Accept': 'text/plain'
          'Content-Type': 'text/plain'
        data: data
        timeout: 2000
      ).then (response)->
        response.data

    @_newRelay()

  # relay commands
  messageCount: (mailbox)->
    mailbox.connectToRelay(@relay).then =>
      mailbox.relayCount(@relay).then (count)->
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
      next = @Mailbox.fromSecKey(options.secret.fromBase64(), mailboxName).then (mailbox)->
        console.log "created mailbox #{mailboxName}:#{options.secret} from secret"
        mailbox
    else if options.seed
      next = @Mailbox.fromSeed(options.seed, mailboxName).then (mailbox)->
        console.log "created mailbox #{mailboxName}:#{options.seed} from seed"
        mailbox
    else
      next = @Mailbox.new(mailboxName).then (mailbox)->
        console.log "created mailbox #{mailboxName} from scratch"
        mailbox

    next.then (mailbox)=>
      @messageCount(mailbox).then =>
        # share keys among mailboxes
        tasks = []
        for name, mbx of @mailboxes
          ((name, mbx)->
            tasks.push mbx.keyRing.addGuest(mailbox.identity, mailbox.getPubCommKey()).then ->
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
    @relay = new @Relay(@relayUrl())

angular
  .module 'app'
  .service 'RelayService', [
    '$q'
    '$http'
    '$window'
    RelayService
  ]
