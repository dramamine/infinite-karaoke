# used to track application state
angular.module('karaoke.tweaks').controller 'FeedbackCtrl',
['$scope', 'DataService', '$log',
  ($scope, DataService, $log) ->

    $scope.rating = null
    $scope.category = null
    $scope.otherVideos = []
    $scope.FEEDBACK_OPTIONS = DataService.FEEDBACK_OPTIONS

    # Sets the rating. Rating is used for logic in the rest of the view.
    #
    # @param rating Int Either 1 for good or -1 for bad.
    # @return null
    $scope.setRating = (rating) ->
      $scope.rating = rating

      if rating == 1

        # this is a promise, but we don't want to do anything with it atm
        DataService.submitFeedback(
          $scope.$parent.video._id,
          rating,
          0,
          DataService.TYPE_VIDEO
        )

      if rating == -1
        DataService.getVideos($scope.$parent.trackid).then (result) ->
          $scope.otherVideos = result.filter (vid) ->
            return vid._id != $scope.$parent.video._id
          console.log $scope.otherVideos
        , (err) ->
          $log.error 'error from setRating fn'


    # Sets the category of the comment. Categories are details on why the user
    # thought the video was bad.
    #
    # @param category Int A categroy ID (see DataService for definitions)
    # @return null
    $scope.setCategory = (category) ->
      $scope.category = category
      $log.info 'Got ' + category + ' for more vid feedback'

      # this is a promise, but we don't want to do anything with it atm
      DataService.submitFeedback(
        $scope.$parent.video._id,
        $scope.rating,
        category,
        DataService.TYPE_VIDEO
      )

      if category == 4
        DataService.demoteVideo($scope.$parent.video._id)

    $scope.promoteVideo = (video) ->
      DataService.promoteVideo(video._id).then (result) ->
        $log.info 'feedback accepted!'
      , (err) ->
        $log.error 'feedback rejected!'

    # Resets the feedback controller to initial state.
    #
    # @return null
    $scope.reset = () ->
      # console.log 'reset called.'
      $scope.rating = null
      $scope.category = null
      $scope.otherVideos = []

    $scope.createVideo = () ->
      $log.info 'createVideo', $scope.new_youtube_id

      DataService.createVideo($scope.$parent.trackid, $scope.new_youtube_id);

    return null
]

