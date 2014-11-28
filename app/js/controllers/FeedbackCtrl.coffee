# used to track application state
angular.module('karaoke.controllers').controller 'FeedbackCtrl', ['$scope', 'DataService',
  ($scope, DataService) ->

    $scope.rating = null
    $scope.category = null
    $scope.otherVideos = []
    $scope.FEEDBACK_OPTIONS = DataService.FEEDBACK_OPTIONS

    $scope.setRating = (newValue) ->
      $scope.rating = newValue
      if newValue == 1
        DataService.submitFeedback $scope.video._id, newValue, 0, DataService.TYPE_VIDEO

      if newValue == 0
        console.log 'Would gather other videos here.'



    $scope.setCategory = (newValue) ->
      $scope.category = newValue
      console.log 'Got ' + newValue + ' for more vid feedback'

      DataService.submitFeedback $scope.video._id, $scope.rating, newValue, DataService.TYPE_VIDEO
    return null
]

