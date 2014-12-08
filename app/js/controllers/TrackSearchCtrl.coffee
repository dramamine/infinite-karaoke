angular.module('karaoke.controllers').controller 'TrackSearchCtrl', [
  '$scope', 'DataService', '$q', '$log',
  ($scope, DataService, $q, $log) ->
    $scope.myData = {}
    $scope.tracks = []
    $scope.selectedTrack
    $scope.searchTerms = ''
    $scope.placeholder = false

    page = 0

    $scope.$watch 'trackid', (trackid) ->
      $scope.$parent.trackid = trackid
      $scope.userAddedTrackId = trackid
      $scope.$parent.hasSearched = true

    # Function called when user picks a track.
    $scope.pickTrack = ->
      $log.info 'pickTrack called.'
      $log.info $scope.selectedTrack

      $scope.$parent.trackid = $scope.selectedTrack.value
      $scope.userAddedTrackId = $scope.selectedTrack.value
      $scope.$parent.hasSearched = true

    $scope.searchTermsUpdated = ->
      page = 0

      # console.log 'searchTermsUpdated called with search terms ' + $scope.searchTerms
      DataService.searchFor($scope.searchTerms).then (tracks) ->
        $log.info tracks

        if $scope.searchTerms != ''
          $scope.placeholder = true
        else
          $scope.placeholder = false

        $scope.tracks = tracks

    $scope.moreResults = ->
      page++

      DataService.searchFor($scope.searchTerms, page).then (tracks) ->
        $log.info tracks
        $scope.tracks = tracks


    # do this once on initialization
    $scope.searchTermsUpdated()


    return null

]

