# used to track application state
angular.module('karaoke.controllers').controller 'StateCtrl', ['$scope',
  ($scope) ->
    $scope.hasSearched = false
    $scope.trackid = null

    $scope.userAddedTrackId = null

    return null
]

