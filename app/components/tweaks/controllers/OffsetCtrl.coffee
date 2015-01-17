# used to track application state
angular.module('karaoke.tweaks').controller 'OffsetCtrl',
['$scope', 'DataService', '$log',
  ($scope, DataService, $log) ->
    console.log 'OffsetCtrl loaded'
    $scope.rating = null

    $scope.setRating = (rating) ->
      console.log 'GREAT, offset setRating was called'
      $scope.rating = rating
      if rating == 1
        # this is a promise, but we don't want to do anything with it atm
        DataService.submitFeedback(
          $scope.video._id,
          rating,
          0,
          DataService.TYPE_LYRIC
        )



    return null
]
