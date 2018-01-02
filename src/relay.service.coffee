class RelayService
  mailboxes: {}

  constructor: (@$q, $http, @$window) ->
    if @$window.location.origin.indexOf('github.io') > -1
      # Use test server by default
      # when running on http://vault12.github.io/zax-dash/
      @relayUrl = 'https://zax-test.vault12.com'
    else
      # Take care not to mix up ports of these services when
      # both are running locally
      @relayUrl = @$window.location.origin

    @Mailbox = @$window.glow.MailBox
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

    @_initRelay()

  changeRelay: (newUrl) ->
    @relayUrl = newUrl
    @_initRelay()

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

  _initRelay: ->
    @$window.glow.CryptoStorage.startStorageSystem(
      new @$window.glow.SimpleStorageDriver @relayUrl)
    @relay = new @$window.glow.Relay @relayUrl

angular
  .module 'app'
  .service 'RelayService', [
    '$q'
    '$http'
    '$window'
    RelayService
  ]
