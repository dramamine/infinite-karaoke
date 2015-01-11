angular.module('karaoke.services').factory 'cast', [
  '$rootScope','$window', ($rootScope, $window) ->

    console.log 'Cast service is being initialized'
    # Timeout to initialize the API
    if (!chrome.cast || !chrome.cast.isAvailable)
      setTimeout(initializeCastApi, 1000)


    CAST_APP_ID = 'something'
    MESSAGE_NAMESPACE = 'somethingelse'

    # Initialize the Google Cast API for use
    initializeCastApi = ->
      unless (chrome.cast && chrome.cast.isAvailable)
        setTimeout(initializeCastApi, 1000)
        return

      sessionRequest = new $window.chrome.cast.SessionRequest(CAST_APP_ID)
      apiConfig = new $window.chrome.cast.ApiConfig(sessionRequest, sessionListener, receiverListener)
      $window.chrome.cast.initialize apiConfig, onInitSuccess, onError

      # Broadcast event for initializing API
      console.log 'Initializing API'
      $rootScope.$broadcast 'INITIALIZING_CAST_API'
      return
    sessionListener = (e) ->
      console.log 'New Session ID:', e.sessionId
      castSession = e
      castSession.addUpdateListener sessionUpdateListener
      castSession.addMessageListener MESSAGE_NAMESPACE, receiverMessage
      return
    onInitSuccess = ->
      console.log 'Successfully Initialized'
      return
    onSuccess = (message) ->
      console.log 'Success:', message
      return
    onError = (message) ->
      console.log 'Error Received:', message
      return
    receiverMessage = (namespace, message) ->
      console.log 'Receiver Message (' + namespace + '):', message
      return
    receiverListener = (e) ->
      console.log 'Receiver Listener:', e
      if e is 'available'

        # Broadcast event for cast available
        console.log 'Receiver Available'
        $rootScope.$broadcast 'RECEIVER_AVAILABLE'
      return
    sessionUpdateListener = (isAlive) ->
      unless isAlive
        castSession = null

        # Broadcast event for cast available
        console.log 'Session Dead'
        $rootScope.$broadcast 'RECEIVER_DEAD'
      return
    castSession = null
    setTimeout initializeCastApi, 1000  if not chrome.cast or not chrome.cast.isAvailable
    return startChromeCast: (message) ->
      if castSession?
        castSession.sendMessage MESSAGE_NAMESPACE, JSON.stringify(message), onSuccess, onError
      else
        chrome.cast.requestSession (e) ->
          castSession = e
          castSession.sendMessage MESSAGE_NAMESPACE, JSON.stringify(message), onSuccess, onError
          return

      return
]


























# angular.module('karaoke.services').service('cast', ['$window', '$rootScope', '$q',
#   ($window, $rootScope, $q) ->


  #   NAMESPACE = "urn:x-cast:org.dutchaug.ccparty"
  #   this.CAST_MESSAGE = "cast-message"
  #   this.CAST_READY = "cast-ready"
  #   this.SENDER_CONNECTED = "sender-connected"
  #   this.SENDER_DISCONNECTED = "sender-disconnected"
  #   receiverManager = null
  #   messageBus = null
  #   service = this
  #   initPromise = $q.defer()

  #   initializeCast = () ->
  #     receiverManager = $window.cast.receiver.CastReceiverManager.getInstance()
  #     receiverManager.onSenderConnected = (event) ->
  #       $rootScope.$apply () ->
  #         $rootScope.$broadcast(service.SENDER_CONNECTED, event)

  #     receiverManager.onSenderDisconnected = (event) ->
  #       $rootScope.$apply () ->
  #         $rootScope.$broadcast(service.SENDER_DISCONNECTED, event)

  #     messageBus = receiverManager.getCastMessageBus(NAMESPACE, cast.receiver.CastMessageBus.MessageType.JSON)
  #     messageBus.onMessage = (event) ->
  #       $rootScope.$apply ->
  #         $rootScope.$broadcast(service.CAST_MESSAGE, event)

  #     receiverManager.start()
  #     initPromise.resolve(receiverManager)
  #     $rootScope.$broadcast(service.CAST_READY, receiverManager)

  #   this.boot = ->
  #     $window.onload = ->
  #       $rootScope.$apply ->
  #         initializeCast()

  #   this.initialized = ->
  #     return initPromise


  #   this.finish = ->
  #     receiverManager.stop()
  #     initPromise = $q.defer()

  #   this.broadcast = (message) ->
  #     messageBus.broadcast(message)

  #   return null

  # ]).run (cast) ->
  #   cast.boot()
