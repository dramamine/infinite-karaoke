# for communicating with Chromecast
angular.module('karaoke.chromecast.sender').controller 'ChromecastCtrl',
['$scope', '$log', '$window', 'cast', '$rootScope', '$timeout',
  ($scope, $log, $window, cast, $rootScope, $timeout) ->

    $scope.status = null

    $scope.state = 'Initializing Cast Api'
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

    ##Listen to the different states
    $rootScope.$on "INITIALIZING_CAST_API", ->
      $log.info "Caught Event! initialize"
      $scope.state = "Initializing Cast Api"
      $scope.disabled = true
      $scope.status = 'initializing'
      $scope.$apply()
      return

    $rootScope.$on "RECEIVER_AVAILABLE", ->
      $log.info "Caught Event! available"
      $scope.state = "Send to Chrome Cast"
      $scope.status = 'available'
      $scope.disabled = false

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

    $rootScope.$on "RECEIVER_DEAD", ->
      $log.info "Caught Event! dead"
      $scope.state = "Receiver Died, Refresh Page"
      $scope.status = 'dead'
      $scope.disabled = true
      $scope.$apply()
      return


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



