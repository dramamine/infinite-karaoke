'use strict'

# Controllers

allControllers = angular.module('allControllers', ['allServices'])

allControllers.controller 'TrackSearchCtrl', ['$scope', 'TrackService', 
  ($scope, TrackService) -> 

    $scope.tracks = TrackService.data

    TrackService.getData().then (newData) ->
      $scope.tracks = newData

    return null

]
