

angular.module('karaoke.controllers').controller 'TrackSearchCtrl', [
  '$scope', '$resource', 
  ($scope, $resource) -> 
    $scope.myData = {}
    # load placeholder data
    #$scope.tracks = TrackService.data
    $scope.tracks = []
    #$scope.myData.tracks = TrackService.data
    $scope.selectedTrack
    #$scope.myData.selectedTrack = 'Test - Test'

    console.log 'updated'

    $scope.pickTrack = ->
      console.log "pickTrack called."
      console.log $scope.selectedTrack

      $scope.$parent.trackid = $scope.selectedTrack.value
      $scope.userAddedTrackId = $scope.selectedTrack.value
      $scope.$parent.hasSearched = true

      


    # not a router, I swear.
    # This is kinda dirty, since "selectedTrack" is either a JSON object with
    # track data, or just the text that the user entered.
    $scope.pickUrl = ->
      if $scope.selectedTrack.value
        # LOL HAX
        # JUST LOAD THE OLD VERSION OF THE PAGE
        # it uses jQuery and all this shit
        # I could write a new directive...some day.
        # 
        # return '#/track/' + $scope.selectedTrack.value
        return '/karaoke/' + $scope.selectedTrack.value
      return '#/search/' + $scope.selectedTrack



    # get tracks from the database
    # @see routes/api.coffee
    url = "/api/track"
    resource = $resource(url)
    resource.query {}, (result) ->

      # convert to menu-items
      # TODO probs shouldn't do this in the controller, but whatever.
      angular.forEach result, (track) ->
        # use the label since this gets indexed
        track.label = track.artist + " - " + track.title
        track.value = track._id

        # TODO placeholder for now
        track.vidQualityCSS = "color:silver"

      $scope.tracks = result

      console.log result

    return null

]

