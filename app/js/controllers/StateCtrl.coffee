# used to track application state
angular.module('karaoke.controllers').controller 'StateCtrl',
['$scope', 'DEBUG', ($scope, DEBUG) ->
  $scope.hasSearched = false
  $scope.trackid = null

  $scope.userAddedTrackId = null

  $scope.DEBUG = DEBUG

  return null
]

