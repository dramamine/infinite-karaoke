angular.module('karaoke.search').controller 'TrackSearchCtrl', [
  '$rootScope', '$scope', 'DataService', '$q', '$log',
  ($rootScope, $scope, DataService, $q, $log) ->
    $scope.myData = {}
    $scope.tracks = []
    $scope.selectedTrack
    $scope.searchTerms = ''
    $scope.placeholder = false

    page = 0

    $scope.$watch 'trackid', (trackid) ->
      # sometimes this gets 'undefined' from ng-init
      return unless trackid
      pickTrack(trackid)

    # Function called when user picks a track.
    $scope.pickTrack = (trackid)->
      $log.info 'pickTrack called. gonna broadcast addTrack..'

      # wanna get rid of this..
      # $scope.$parent.trackid = trackid
      # $scope.userAddedTrackId = trackid

      $rootScope.$broadcast 'addTrack', trackid

      $scope.$parent.hasSearched = true

    $scope.searchTermsUpdated = ->
      page = 0

      DataService.searchFor($scope.searchTerms).then (tracks) ->
        $log.info tracks

        # use a placeholder when the user searched for something
        $scope.placeholder = ($scope.searchTerms != '')

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

