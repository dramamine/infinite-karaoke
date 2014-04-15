'use strict'

# Controllers

allControllers = angular.module('allControllers', ['allServices'])

allControllers.controller 'TrackSearchCtrl', ['$scope', 'SampleService', 
  ($scope, SampleService) -> 

    $scope.data = SampleService.data

    return null

]
