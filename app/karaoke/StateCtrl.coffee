# used to track application state
angular.module('karaoke').controller 'StateCtrl',
['$scope', 'DEBUG', ($scope, DEBUG) ->
  $scope.trackid = null

  $scope.DEBUG = DEBUG

  $scope.visibility =
    'feedback': false
    'offset': false
    'karaoke': false

  $scope.state = 'inactive'

  $scope.$on 'addTrack', (evt) ->
    $scope.state = 'loading'
    $scope.visibility.feedback = false
    $scope.visibility.offset = false
    $scope.visibility.karaoke = true

  $scope.$on 'playVideo', (evt) ->
    $scope.state = 'playing'
    $scope.visibility.feedback = true
    $scope.visibility.offset = true

  $scope.$on 'endVideo', (evt) ->
    $scope.state = 'inactive'

  return null
]

