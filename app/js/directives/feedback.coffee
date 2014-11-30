
angular.module('karaoke.directives').directive 'feedback', ->
  return {
    restrict: 'E'
    controller: 'FeedbackCtrl'
    replace: true
    templateUrl: '../partials/feedback.html'
  }