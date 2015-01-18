
angular.module("karaoke.chromecast.receiver").controller "ReceiverCtrl", [
  "$scope"
  '$rootScope'
  "GoogleCastMessageBus"
  "$timeout"
  "$http"
  '$log'
  ($scope, $rootScope, GoogleCastMessageBus, $timeout, $http, $log) ->
    $scope.view = "table"
    $scope.filter = 4
    $scope.consoleMessage = "No console selected!"
    $scope.games = []
    GoogleCastMessageBus.onMessage = (e) ->

      # eh, we could validate this...
      unless e.data && e.data.action
        $log.error "message didn't have an action :("
        $log.error e
        return false

      $rootScope.broadcast e.data.action, e.data.message
      # apply, maybe?
      # $scope.$apply()
      return true






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