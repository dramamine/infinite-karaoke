angular.module('karaoke.controllers').controller 'TrackSearchCtrl', [
  '$scope', 'DataService', '$q', '$log',
  ($scope, DataService, $q, $log) ->
    $scope.myData = {}
    $scope.tracks = []
    $scope.selectedTrack

    DataService.getTrackList().then (tracks) ->
      $log.info tracks
      $scope.tracks = tracks

      # if trackid is set, user's using parameters to choose a track.
      if $scope.trackid
        mytrack = tracks.filter (i) ->
          return i._id == $scope.trackid
        if mytrack.length == 1
          $scope.selectedTrack = mytrack[0]
          $scope.pickTrack()

    , (error) ->
      $log.error 'error from getting track list.'


    # Function called when user picks a track.
    $scope.pickTrack = ->
      $log.info 'pickTrack called.'
      $log.info $scope.selectedTrack

      $scope.$parent.trackid = $scope.selectedTrack.value
      $scope.userAddedTrackId = $scope.selectedTrack.value
      $scope.$parent.hasSearched = true




    return null

]

