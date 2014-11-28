

angular.module('karaoke.controllers').controller 'TrackSearchCtrl', [
  '$scope', 'DataService', '$q',
  ($scope, DataService, $q) ->
    $scope.myData = {}
    $scope.tracks = []
    $scope.selectedTrack


    $scope.pickTrack = ->
      console.log "pickTrack called."
      console.log $scope.selectedTrack

      $scope.$parent.trackid = $scope.selectedTrack.value
      $scope.userAddedTrackId = $scope.selectedTrack.value
      $scope.$parent.hasSearched = true



    promise = DataService.getTrackList()
    promise.then (response) ->
      console.log response
      $scope.tracks = response

      # user's using parameters to choose a track.
      if $scope.trackid
        mytrack = response.filter (i) ->
          return i._id == $scope.trackid
        if mytrack.length == 1
          $scope.selectedTrack = mytrack[0]
          $scope.pickTrack()

    , (error) ->
      console.log 'did not work.'

    return null

]

