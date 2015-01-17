
angular.module('karaoke.display').directive 'karaoke', ->
  return {
    restrict: 'AE'
    scope: {
      'trackid': '=' # probs get rid of this
    }
    controller: 'KaraokeCtrl'
    # require: '^TrackSearchCtrl'
    templateUrl: '../partials/karaoke.html'
    link: (scope, elem, attr) ->

      # HEY. not sure if this is ever being used, might be better to call
      # straight from whatever's changing the trackid.
      scope.$watch 'trackid', (newVal) ->
        if newVal
          scope.queueTrack newVal

        return null

      return null
  }