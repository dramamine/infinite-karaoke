
angular.module('karaoke.directives').directive 'offset', ->
  return {
    restrict: 'E'
    controller: 'OffsetCtrl'
    replace: true
    templateUrl: '../partials/offset.html'

  }