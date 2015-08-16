# for communicating with Chromecast
angular.module('karaoke.chromecast.sender').controller 'ChromecastCtrl',
['$scope', '$log', '$window', 'cast', '$rootScope', '$timeout',
  ($scope, $log, $window, cast, $rootScope, $timeout) ->


    # $scope.status = null

    # $scope.state = 'Initializing Cast Api'
    $scope.buttonText = 'Looking for Chromecast...'
    $scope.buttonClass = 'btn cc-button-initializing'
    hi =
      hi: 'hi'
      trackid: 'xyz'
      action: 'play'




    addTrack = (trackid) ->
      # I'm debugging!
      return

      $log.info 'sending out addTrack with ', trackid
      if !$scope.disabled
        cast.sendMessage
          action: 'addTrack'
          trackid: trackid
      else
        $log.info 'waiting 3 seconds...'
        $timeout( () ->
          addTrack(trackid)
        , 3000)

    $scope.$on 'addTrack', addTrack

    $rootScope.$on cast.STATUS_UPDATE, (evt, update) ->
      $log.info 'cast status update received', update
      if $scope.status == update
        return
      $scope.status = update

      switch update
        when 'initializing' then $scope.buttonText = 'Initializing Chromecast...'
        when 'initialized' then $scope.buttonText = 'Play on Chromecast'
        when 'available' then $scope.buttonText = 'Play on Chromecast'
        when 'dead' then $scope.buttonText = 'Refresh page to connect to Chromecast'
        when 'sending' then $scope.buttonText = 'Connecting to Chromecast...'
        when 'session-active' then $scope.buttonText = 'Playing on Chromecast!'

      $scope.buttonClass = 'btn cc-button-' + update

      $timeout ->
        $scope.$apply()

      return


    $scope.sendTestMessage = ->
      cast.sendMessage "wtf is going on"
      return

    $scope.addTestTrack = ->
      cast.sendMessage
        action: 'addTrack'
        trackid: '547782a8ad1c9c711908abd6'

    $scope.addTrack = (evt, data) ->
      $log.info 'adding track (cc ctrl)', evt, data
      cast.sendMessage data


    $scope.chromecastClick = ->
      switch $scope.status
        when 'available'
          cast.sendMessage "handshake"
        # when 'dead'
        #   $log.info 'trying to rinitlaize'
        #   cast.initializeCastApi()

    # # Send the data to the chrome cast
    # $scope.sendToCast = ->
    #   GoogleCastSession.startChromeCast
    #     view: $scope.view
    #     filter: $scope.filter
    #     console: $scope.console

    return






    # old code
    # $scope.$on cast.CAST_READY, (e, manager) ->
    #   $log.info 'Jesus christ we got the message'


    return null
]



