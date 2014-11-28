# used to track application state
angular.module('karaoke.controllers').controller 'FeedbackCtrl', ['$scope', '$http',
  ($scope, $http) ->

    $scope.videoFeedback = null
    $scope.videoMoreFeedback = null
    $scope.otherVideos = []

    $scope.setVideoFeedback = (newValue) ->
      $scope.videoFeedback = newValue
      if newValue == 1
        console.log 'Would submit an $http request here.'

      if newValue == 0
        console.log 'Would gather other videos here.'



    $scope.setVideoMoreFeedback = (newValue) ->
      console.log 'Got ' + newValue + ' for more vid feedback'

    return null
]

