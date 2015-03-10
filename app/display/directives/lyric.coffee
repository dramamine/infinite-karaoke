##
# Used for lyric animations.
##
angular.module('karaoke.display').directive 'lyric', ($log, $animate) ->
  return {
    restrict: 'AE'
    scope:
      action: '='

    link: (scope, element) ->
      $log.info 'Linking up my lyric directive.'

      scope.$watch "action", (action) ->
        $log.info 'Action changed to ' + action + '.'

        $animate.removeClass(element, 'enterbottom')
        $animate.removeClass(element, 'exittop')
        $animate.removeClass(element, 'entertop')
        $animate.removeClass(element, 'hideme')

        switch action
          when 'enterbottom'
            $animate.addClass(element, 'enterbottom')
          when 'exittop'
            $animate.addClass(element, 'exittop')
          when 'entertop'
            $animate.addClass(element, 'entertop')
          else
            $animate.addClass(element, 'hideme')

        return null

  }