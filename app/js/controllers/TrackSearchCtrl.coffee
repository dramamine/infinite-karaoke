

angular.module('karaoke.controllers').controller 'TrackSearchCtrl', [
  '$scope', 'TrackService', '$q',
  ($scope, TrackService, $q) ->
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



    promise = TrackService.getTrackList()
    promise.then (response) ->
      console.log response
      $scope.tracks = response
    , (error) ->
      console.log 'did not work.'

    return null

]

