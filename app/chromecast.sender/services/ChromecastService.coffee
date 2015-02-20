angular.module('karaoke.chromecast.sender').service 'cast', [
  '$rootScope','$window', '$log', 'CAST_APP_ID', 'MESSAGE_NAMESPACE',
  ($rootScope, $window, $log, CAST_APP_ID, MESSAGE_NAMESPACE) ->

    $log.info 'Cast service is being initialized'
    # Timeout to initialize the API
    if (!chrome.cast || !chrome.cast.isAvailable)
      setTimeout(initializeCastApi, 1000)

    # Initialize the Google Cast API for use
    initializeCastApi = ->

      unless (chrome.cast && chrome.cast.isAvailable)
        setTimeout(initializeCastApi, 1000)
        return

      sessionRequest = new chrome.cast.SessionRequest(CAST_APP_ID)
      apiConfig = new chrome.cast.ApiConfig(sessionRequest, sessionListener,
        receiverListener)
      chrome.cast.initialize apiConfig, onInitSuccess, onError

      # Broadcast event for initializing API
      $log.info 'Initializing API'
      $rootScope.$broadcast 'INITIALIZING_CAST_API'
      return
    sessionListener = (e) ->
      $log.info 'New Session ID:', e.sessionId
      castSession = e
      castSession.addUpdateListener sessionUpdateListener
      castSession.addMessageListener MESSAGE_NAMESPACE, receiverMessage
      return
    onInitSuccess = ->
      $log.info 'Successfully Initialized'
      return
    onSuccess = (message) ->
      $log.info 'Success:', message
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
      return
    sessionUpdateListener = (isAlive) ->
      unless isAlive
        castSession = null

        # Broadcast event for cast available
        $log.info 'Session Dead'
        $rootScope.$broadcast 'RECEIVER_DEAD'
      return
    castSession = null
    setTimeout initializeCastApi, 1000  if not chrome.cast or
      not chrome.cast.isAvailable

    obj =

      sendMessage: (message) ->
        $log.info 'attempting to send this message', message
        if castSession?
          castSession.sendMessage MESSAGE_NAMESPACE, JSON.stringify(message),
            onSuccess, onError
        else
          chrome.cast.requestSession (e) ->
            castSession = e
            castSession.sendMessage MESSAGE_NAMESPACE, JSON.stringify(message),
              onSuccess, onError
        return

    return obj


]