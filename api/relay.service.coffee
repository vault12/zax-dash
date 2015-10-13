class RelayService
  host: ""
  headers: {"Content-Type": "text/plain"}
  mailboxes: {}


  constructor: (@$http, @$q, @CryptoService, $location, @base64)->
    @host = 'http://104.236.171.11' #$location.host()
    @_newSession()

  # relay commands

  startSession: ->
    deffered = @$q.defer()
    deffered.resolve @session.getServerToken()
    deffered.promise

  verifySession: ->
    deffered = @$q.defer()
    deffered.resolve @session.getServerKey()
    deffered.promise

  connectMailbox: (mailbox)->
    deffered = @$q.defer()
    deffered.resolve @session.connectMailbox mailbox
    deffered.promise

  runCommand: (command, mailbox)->
    deffered = @$q.defer()
    deffered.resolve @session.runCmd(command, mailbox)
    deffered.promise

  # mailbox wrapper
  newMailbox: (mailboxName)->
    return unless mailboxName
    @mailboxes[mailboxName] = new @CryptoService.glow.MailBox(mailboxName)



  # internal stuffs

  _newSession: ->
    @session = new @CryptoService.glow.Relay(@host)
    @session.client_token_text = @_randomString()

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
    'base64'
    RelayService
  ]
