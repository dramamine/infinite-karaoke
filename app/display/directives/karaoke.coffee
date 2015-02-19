
angular.module('karaoke.display').directive 'karaoke', ->
  return {
    restrict: 'AE'
    scope: {
      'trackid': '=' # probs get rid of this
    }
    controller: 'KaraokeCtrl'
    # require: '^TrackSearchCtrl'
    templateUrl: 'karaoke.jade'
  }