angular.module('karaoke.chromecast.sender').service 'cast', [
  '$rootScope','$window', '$log', 'CAST_APP_ID', 'MESSAGE_NAMESPACE',
  ($rootScope, $window, $log, CAST_APP_ID, MESSAGE_NAMESPACE) ->

    STATUS_UPDATE = 'STATUS_UPDATE'

    $log.info 'Cast service is being initialized'
    # Timeout to initialize the API
    if (!chrome.cast || !chrome.cast.isAvailable)
      setTimeout(initializeCastApi, 1000)

    # Initialize the Google Cast API for use
    initializeCastApi = ->

      unless (chrome.cast && chrome.cast.isAvailable)
        setTimeout(initializeCastApi, 1000)
        return
      # Broadcast event for initializing API
      $log.info 'Initializing API'

      $rootScope.$broadcast STATUS_UPDATE, 'initializing'

      sessionRequest = new chrome.cast.SessionRequest(CAST_APP_ID)
      apiConfig = new chrome.cast.ApiConfig(sessionRequest, sessionListener,
        receiverListener)
      chrome.cast.initialize apiConfig, onInitSuccess, onInitError

      return
    sessionListener = (e) ->
      $log.info 'New Session ID:', e.sessionId
      castSession = e
      castSession.addUpdateListener sessionUpdateListener
      castSession.addMessageListener MESSAGE_NAMESPACE, receiverMessage
      $rootScope.$broadcast STATUS_UPDATE, 'session-active'
      return
    onInitSuccess = ->
      $log.info 'Successfully Initialized'
      $rootScope.$broadcast STATUS_UPDATE, 'initialized'
      return
    onSendMsgSuccess = (message) ->
      $log.info 'Success:', message
      $rootScope.$broadcast STATUS_UPDATE, 'session-active'
      return
    onInitError = (message) ->
      $log.info 'Init Error Received:', message
      return
    onError = (message) ->
      $log.info 'Error Received:', message
      return
    receiverMessage = (namespace, message) ->
      $log.info 'Receiver Message (' + namespace + '):', message
      return
    receiverListener = (e) ->
      $log.info 'Receiver Listener:', e
      if e is 'available'

        # Broadcast event for cast available
        $log.info 'Receiver Available'
        $rootScope.$broadcast 'RECEIVER_AVAILABLE'
        $rootScope.$broadcast STATUS_UPDATE, 'available'
      return
    sessionUpdateListener = (isAlive) ->
      unless isAlive
        castSession = null

        # Broadcast event for cast available
        $log.info 'Session Dead'
        status = 'dead'
        $rootScope.$broadcast 'RECEIVER_DEAD'

        $rootScope.$broadcast STATUS_UPDATE, status
      return
    castSession = null
    setTimeout initializeCastApi, 1000  if not chrome.cast or
      not chrome.cast.isAvailable

    obj =
      STATUS_UPDATE: STATUS_UPDATE,
      initializeCastApi: initializeCastApi,
      sendMessage: (message) ->
        $log.info 'attempting to send this message', message
        if castSession?
          castSession.sendMessage MESSAGE_NAMESPACE, JSON.stringify(message),
            onSendMsgSuccess, onError
        else
          chrome.cast.requestSession (e) ->
            castSession = e
            castSession.sendMessage MESSAGE_NAMESPACE, JSON.stringify(message),
              onSendMsgSuccess, onError

        $rootScope.$broadcast STATUS_UPDATE, 'sending'

        return



    return obj


]