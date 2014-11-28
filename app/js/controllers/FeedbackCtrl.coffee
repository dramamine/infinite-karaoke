# used to track application state
angular.module('karaoke.controllers').controller 'FeedbackCtrl', ['$scope', 'TrackService',
  ($scope, TrackService) ->

    $scope.rating = null
    $scope.category = null
    $scope.otherVideos = []

    $scope.setRating = (newValue) ->
      $scope.rating = newValue
      if newValue == 1

        console.log 'Would submit an $http request here.'

      if newValue == 0
        console.log 'Would gather other videos here.'



    $scope.setCategory = (newValue) ->
      $scope.category = newValue
      console.log 'Got ' + newValue + ' for more vid feedback'

      TrackService.submitFeedback '547782acad1c9c711908b90f', $scope.rating, newValue, TrackService.TYPE_VIDEO
    return null
]

