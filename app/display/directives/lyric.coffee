
angular.module('karaoke.display').directive 'lyric', ($log, $animate) ->
  return {
    restrict: 'AE'
    scope:
      action: '='
      text: '='
      finished: '&'
    # transclude: true

    # require: '^TrackSearchCtrl'
    # templateUrl: 'karaoke.jade'
    link: (scope, element) ->
      $log.info 'Linking up my lyric directive.'
      # initialize the element
      # $(element).textillate()
      # $(element).on 'start.tlt', ->
      #   console.log("TLT started from directive, WHOA")

      # why update text like this?
      # https://github.com/jschr/textillate/issues/55
      # scope.$watch "text", (text) ->
      #   $(element).find('.texts li:first').text(text)
      #   $(element).textillate('start')

      scope.finished = scope.finished || ->
        return null

      scope.$watch "text", (text) ->
        $(element).text(text)

      scope.$watch "action", (action) ->
        $log.info 'Action changed to ' + action + '.'

        $animate.removeClass(element, 'myenter')
        $animate.removeClass(element, 'myleave')
        $animate.removeClass(element, 'enterbottom')
        $animate.removeClass(element, 'exittop')
        $animate.removeClass(element, 'entertop')
        $animate.removeClass(element, 'hideme')


        myelement = element

        switch action

          when 'entering'
            $animate.addClass(element, 'myenter')
          when 'exiting'
            $animate.addClass(element, 'myleave')
          when 'enterbottom'
            $animate.addClass(element, 'enterbottom iambottom')
          when 'exittop'
            $animate.addClass(element, 'exittop')
          when 'entertop'
            $animate.removeClass(element, 'iambottom')
            $animate.addClass(element, 'entertop iamtop')
          else
            $animate.addClass(element, 'hideme')

        return null



        # $(element).removeClass('animated fadeOutUp fadeInUp pulse ')
        # switch action

        #   when 'entering'

        #     $(element).addClass('animated fadeInUp')


        #   when 'exiting'
        #     $(element).addClass('animated fadeOutUp')


        #   when 'pulsing'
        #     $(element).addClass('animated pulse')



  }