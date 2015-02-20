angular.module("karaoke.chromecast.receiver").factory "GoogleCastMessageBus", [
  "MESSAGE_NAMESPACE"
  (MESSAGE_NAMESPACE) ->

    # Initialize the chromecast
    cast.receiver.logger.setLevelValue 0
    castReceiverManager = cast.receiver.CastReceiverManager.getInstance()
    console.log "Starting Cast Receiver Manager"

    # Handle the 'Ready' event
    castReceiverManager.onReady = (e) ->
      console.log "Ready Event Received:", e
      castReceiverManager.setApplicationState "Angular Cast"
      return


    # Handle the 'SenderConnected' event
    castReceiverManager.onSenderConnected = (e) ->
      console.log "Sender Connected Event Received:", e
      return


    # Handle the 'SenderDisconnected' event
    castReceiverManager.onSenderDisconnected = (e) ->
      console.log "Sender Disconnected Event Received:", e
      return


    # If there castReceiverManager.getSenders().length == 0, can close the
    # window to shut down

    # Create the CastMessageBug to handle messages for the custom namespace
    castMessageBus = castReceiverManager.getCastMessageBus(MESSAGE_NAMESPACE)

    # Initialize the CastReceiverManager with a base application status
    castReceiverManager.start statusText: "Application starting..."
    return castMessageBus
]
