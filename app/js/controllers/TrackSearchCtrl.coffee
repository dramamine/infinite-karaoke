

angular.module('karaoke.controllers').controller 'TrackSearchCtrl', [
  '$scope', 'DataService', '$q',
  ($scope, DataService, $q) ->
    $scope.myData = {}
    # load placeholder data
    #$scope.tracks = DataService.data
    $scope.tracks = []
    #$scope.myData.tracks = DataService.data
    $scope.selectedTrack
    #$scope.myData.selectedTrack = 'Test - Test'

    console.log 'updated'

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
    , (error) ->
      console.log 'did not work.'

    return null

]

