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
        # LOL HAX
        # JUST LOAD THE OLD VERSION OF THE PAGE
        # it uses jQuery and all this shit
        # I could write a new directive...some day.
        # 
        # return '#/track/' + $scope.selectedTrack.value
        return '/local/' + $scope.selectedTrack.value
      return '#/search/' + $scope.selectedTrack

      
    # get tracks from the database
    TrackService.getData().then (newData) ->
      $scope.tracks = newData

    return null

]

allControllers.controller 'PlayCtrl', ['$scope', '$routeParams', 'TrackService', 
  ($scope, $routeParams, TrackService) -> 

    TrackService.lookupTrack( $routeParams.id ).then (newData) ->
      console.log newData

      $scope.data = newData

]