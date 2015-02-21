angular.module('karaoke.search').controller 'TrackSearchCtrl', [
  '$rootScope', '$scope', 'DataService', '$q', '$log', '$timeout',
  ($rootScope, $scope, DataService, $q, $log, $timeout) ->
    $scope.myData = {}
    $scope.tracks = []
    $scope.selectedTrack
    $scope.searchTerms = ''
    $scope.placeholder = false

    page = 0

    $scope.$watch 'trackid', (trackid) ->
      # sometimes this gets 'undefined' from ng-init
      return unless trackid

      # TODO this is a super lazy solution; should check 'state' or something
      # to see if KaraokeCtrl is ready to catch addTrack msg
      $timeout( () ->
        $scope.pickTrack(trackid)
      , 1000 )
      return null

    # Function called when user picks a track.
    $scope.pickTrack = (trackid)->
      console.log 'pickTrack called. broadcasting addTrack'
      $rootScope.$broadcast 'addTrack', trackid

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

