
angular.module('karaoke.directives').directive 'karaoke', ->
  return {
    restrict: 'E'
    scope: {
      'trackid': '=' # probs get rid of this
    }
    controller: 'KaraokeCtrl'
    # require: '^TrackSearchCtrl'
    templateUrl: '../partials/karaoke.html'
    link: (scope, elem, attr) ->

      scope.$watch 'trackid', (newVal) ->
        console.log "trackid changed!"
        if newVal
          # from controller
          scope.queueTrack newVal

        return null

      return null
  }