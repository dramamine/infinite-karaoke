
angular.module("karaoke.receiver").controller "ReceiverCtrl", [
  "$scope"
  "GoogleCastMessageBus"
  "$timeout"
  "$http"
  ($scope, GoogleCastMessageBus, $timeout, $http) ->
    $scope.view = "table"
    $scope.filter = 4
    $scope.consoleMessage = "No console selected!"
    $scope.games = []
    GoogleCastMessageBus.onMessage = (e) ->
      console.log "Message Received:", e.data

      # Parse the setting JSON
      settings = JSON.parse(e.data)
      console.log "Setting", settings

      # Set them on the scope
      $scope.view = settings.hi
      $scope.filter = settings.trackid
      $scope.console = e.data
      $scope.$apply()
      return


    # Fetch games function
    $scope.fetchGames = (device) ->
      console.log "Attempting to fire REST Call for:", device
      $scope.consoleMessage = "Retrieving Games for " + device
      console.log "Hitting URL: https://angular-cast.firebaseio.com/games/" + device + ".json"
      $http(
        method: "GET"
        url: "https://angular-cast.firebaseio.com/games/" + device + ".json"
      ).success((data) ->
        console.log "Success on REST Call:", data
        $scope.games = data
        $scope.consoleMessage = ""
        return
      ).error (e) ->
        console.log "Error on REST Call:", e
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
        console.log "From the TIMEOUT"
        $scope.fetchGames nv
        return
      , 10000)

      # Initial call
      $scope.fetchGames nv
      return

]