'use strict'

# Controllers

allControllers = angular.module('allControllers', ['allServices'])

allControllers.controller 'TrackSearchCtrl', ['$scope', 'TrackService', 
  ($scope, TrackService) -> 

    # load placeholder data
    $scope.tracks = TrackService.data
    $scope.selectedTrack = ''

    # not a router, I swear.
    # This is kinda dirty, since "selectedTrack" is either a JSON object with
    # track data, or just the text that the user entered.
    $scope.pickUrl = ->
      if $scope.selectedTrack.value
        return '#/track/' + $scope.selectedTrack.value
      return '#/search/' + $scope.selectedTrack

      
    # get tracks from the database
    TrackService.getData().then (newData) ->
      $scope.tracks = newData

    return null

]
