
angular.module('karaoke.display').directive 'karaoke', ->
  return {
    restrict: 'AE'
    scope:
      'trackid': '=' # probs get rid of this
    controller: 'KaraokeCtrl'
    templateUrl: 'karaoke.jade'

    link: (scope, element) ->
      angular.element(window).on "webkitTransitionEnd", () ->
        console.log '1 an animation ended =)'

      angular.element(window).on "transitionend", () ->
        console.log '2 an animation ended =)'

      angular.element(window).on "animationend", () ->
        console.log '3 an animation ended =)'


      return null

  }