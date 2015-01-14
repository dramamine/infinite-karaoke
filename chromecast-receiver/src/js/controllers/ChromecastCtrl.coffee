# for communicating with Chromecast
angular.module('karaoke.controllers').controller 'ChromecastCtrl',
['$scope', '$log', '$window', 'cast', '$rootScope',
  ($scope, $log, $window, cast, $rootScope) ->

    $scope.state = 'Initializing Cast Api';
    # cast.initializeCastApi()

    ##Listen to the different states
    $rootScope.$on "INITIALIZING_CAST_API", ->
      console.log "Caught Event! initialize"
      $scope.state = "Initializing Cast Api"
      $scope.disabled = true
      $scope.$apply()
      return

    $rootScope.$on "RECEIVER_AVAILABLE", ->
      console.log "Caught Event! available"
      $scope.state = "Send to Chrome Cast"
      $scope.disabled = false

      hi =
        trackid: 'xyz'
        action: 'play'
      cast.sendMessage hi
      $scope.$apply()
      return

    $rootScope.$on "RECEIVER_DEAD", ->
      console.log "Caught Event! dead"
      $scope.state = "Receiver Died, Refresh Page"
      $scope.disabled = true
      $scope.$apply()
      return


    # Send the data to the chrome cast
    $scope.sendToCast = ->
      GoogleCastSession.startChromeCast
        view: $scope.view
        filter: $scope.filter
        console: $scope.console

    return






    # old code
    # $scope.$on cast.CAST_READY, (e, manager) ->
    #   console.log 'Jesus christ we got the message'


    return null
]



