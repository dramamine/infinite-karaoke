
angular.module("karaoke.chromecast.receiver").controller "ReceiverCtrl", [
  "$scope"
  '$rootScope'
  "GoogleCastMessageBus"
  "$timeout"
  "$http"
  '$log'
  ($scope, $rootScope, GoogleCastMessageBus, $timeout, $http, $log) ->

    $log.info "Nothing happening"
    GoogleCastMessageBus.onMessage = (e) ->
      $log.info 'onMessage function called'
      if !e.data
        $log.info 'no data on this thing!'
        return

      data = JSON.parse e.data
      $log.info 'Processing this data ' + data
      # eh, we could validate this...
      unless data && data.action
        $log.error "message didn't have an action :("
        $log.error e
        return false
      $log.info 'broadcasting message:' + data.action
      $rootScope.$broadcast data.action, data
      $rootScope.$broadcast 'TEST MESSAGE'
      $scope.$broadcast data.action, data
      $rootScope.$apply()


      # HELLO MARTEN
      # you're broadcasting events but nobody's receiving them
      # what gives??

      # apply, maybe?
      # $scope.$apply()
      return true

      $scope.$on 'addTrack', (evt, data) ->
        $log.info 'received addTrack from inside the house'

      $scope.$on 'TEST MESSAGE', () ->
        $log.info 'received TEST MESSAGE from inside the house'



    # Fetch games function
    $scope.fetchGames = (device) ->
      $log.info "Attempting to fire REST Call for:", device
      $scope.consoleMessage = "Retrieving Games for " + device
      $log.info "Hitting URL: https://angular-cast.firebaseio.com/games/" + device + ".json"
      $http(
        method: "GET"
        url: "https://angular-cast.firebaseio.com/games/" + device + ".json"
      ).success((data) ->
        $log.info "Success on REST Call:", data
        $scope.games = data
        $scope.consoleMessage = ""
        return
      ).error (e) ->
        $log.error "Error on REST Call:", e
        $scope.games = []
        $scope.consoleMessage = "ERROR"
        return

      return


    # Watch the console variable, fire rest call to get the data on a timeout
    callTimeout = undefined
    $scope.$watch "console", (nv) ->
      return  unless nv
      $timeout.cancel callTimeout  unless callTimeout

      # Call/refresh every 10s
      callTimeout = $timeout(->
        $log.info "From the TIMEOUT"
        $scope.fetchGames nv
        return
      , 10000)

      # Initial call
      $scope.fetchGames nv
      return

]