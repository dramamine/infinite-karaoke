
angular.module('karaoke.display').controller 'KaraokeCtrl', [
  '$scope', '$rootScope', '$resource', '$youtube', '$timeout', '$log',
  ($scope, $rootScope, $resource, $youtube, $timeout, $log) ->

    # used for the CSS 'progress bar'. basically, we swap the class to
    # 'inactive' for this many milliseconds, before swapping to 'active' with
    # the transition.
    # ...
    # Also using this for new CSS animations

    CSS_TRANSITION_MS = 0


    # if video loads before lyrics, we have to wait for them. (in ms)
    LYRIC_WAITING_CYCLE = 250

    # how often the validator runs
    VALIDATION_CYCLE = 5000


    # how many lines are visible at once
    LINES_TO_SHOW = 2



    currentTime = 0
    $scope.lyrics = []

    lyricIndex = 0
    timer = null
    video = null

    $scope.offset = 69

    validation = null

    currentTrack = null


    # used for the 'progress bar' tracker
    $scope.tracker =
      class: 'lyricbox-inactive'
      style: {}

    # helpful for callbacks
    self = this

    # current lyric being displayed
    $scope.currentLyric = ''


    $scope.$on 'addTrack', (evt, data) ->
      $log.info 'addTrack message received :)'

      # 'data' should only be the trackid.
      unless typeof data == 'string'
        $log.error 'loadTrack called with bad params'
        $log.error data
        $log.error evt
        return false

      $scope.queueTrack data

      return null



    # queues up a track. this is the 'init' function essentially.
    $scope.queueTrack = (newId) ->
      console.log "queueTrack called. querying this ID:" + newId
      currentTrack = newId

      videoApiCall = $resource('/video/:id', {id: newId})
      videoApiCall.get {}, (result) ->
        console.log 'video received.'
        console.log result

        $scope.code = result.youtube_id
        $scope.video = result

        $scope.$emit 'playVideo'

        # autoplay
        $scope.$on 'youtube.player.ready', () ->
          $youtube.player.playVideo()

        $scope.$on 'youtube.player.paused', () ->
          console.log "Cancelling timer."
          $timeout.cancel(timer)
          $timeout.cancel(validation)

          $scope.tracker.style =
            '-webkit-animation-play-state': 'paused'
            'animation-play-state': 'paused'

        $scope.$on 'youtube.player.playing', () ->
          console.log "Video's playing."
          waitForLyrics()
          validation = $timeout( validator, VALIDATION_CYCLE )


      lyricApiCall = $resource('/lyric/' + newId)
      lyricApiCall.get {}, (result) ->
        console.log 'lyric received.'
        console.log result

        $scope.lyrics = result.content


      waitForLyrics = ->
        if $scope.lyrics
          initLyric()
        else
          $log.info 'lyrics not loaded yet, waiting...'
          $timeout( waitForLyrics, LYRIC_WAITING_CYCLE )
      # initializes the lyric control
      initLyric = ->
        # usually called via $on, needs outside reference
        lyrics = $scope.lyrics
        # lyricIndex = self.lyricIndex

        console.log "Init lyric called."

        currentTime = getCurrentTime()

        for lyric, idx in lyrics
          # find the lyric which comes right after the current time
          if lyric.time > currentTime
            self.lyricIndex = idx - 1

            $scope.currentLyric = lyrics[self.lyricIndex].line

            wait = (lyric.time - currentTime - CSS_TRANSITION_MS)
            console.log 'waiting ' + wait + ' for next update'
            if wait < 0
              $log.error 'wait was ' + wait + ' (must be >0)'
              wait = 0

            timer = $timeout( updateLyric, wait )
            updateProgressBar(wait)


            lyricAnimations()

            return null

        return null


      # update to the next lyric
      updateLyric = ->
        # usually called via $timeout, needs outside reference
        lyrics = $scope.lyrics
        self.lyricIndex++

        if lyrics[self.lyricIndex] != null
          $scope.currentLyric = lyrics[self.lyricIndex].line
        else
          console.log 'Uh oh. couldn\'t find lyrics here:' + self.lyricIndex


        if lyrics[self.lyricIndex+1] != null
          # time to wait before showing the next lyric
          wait = lyrics[self.lyricIndex+1].time - getCurrentTime() - CSS_TRANSITION_MS

          if wait < 0
            $log.error 'wait was ' + wait + ' (must be >0)'
            wait = 0

          console.log 'waiting ' + wait + ' for next update'
          timer = $timeout( updateLyric, wait )

          # console.log "Waiting " + wait + " to update again."

          updateProgressBar(wait)

          lyricAnimations()


        return null

      $scope.animCallback = (idx) ->
        console.log 'animCAllback with index ' + idx
        return null

      # call this function on updating lyricIndex
      lyricAnimations = ->
        if $scope.lyrics[self.lyricIndex-1]
          $scope.lyrics[self.lyricIndex-1].action = "exittop"
        if $scope.lyrics[self.lyricIndex]
          $scope.lyrics[self.lyricIndex].action = "entertop"
        if $scope.lyrics[self.lyricIndex+1]
          $scope.lyrics[self.lyricIndex+1].action = "enterbottom"


      # updates the progress bar
      updateProgressBar = (wait) ->
        $scope.tracker =
          class: 'lyricbox-inactive'
          style: {}

        # how long is our wait? (convert to x.x seconds)
        seconds = (Math.floor (wait-CSS_TRANSITION_MS)/100) / 10

        $timeout ->
          $scope.tracker =
            class: 'lyricbox-active'
            style: getTransitionCSS(seconds)
          return null
        , CSS_TRANSITION_MS

      # Helper function for rendering the correct transition CSS to use.
      #
      # @param seconds Number The length of the transition, in seconds
      #                       (ex. '2.4')
      # @return Object A CSS object to be rendered by ng-style
      getTransitionCSS = (seconds) ->
        TYPE = 'linear'
        return {
          '-webkit-transition': 'width ' + seconds + 's ' + TYPE
          '-moz-transition': 'width ' + seconds + 's ' + TYPE
          '-o-transition': 'width ' + seconds + 's ' + TYPE
          '-ms-transition': 'width ' + seconds + 's ' + TYPE
          'transition': 'width ' + seconds + 's ' + TYPE
        }



      # Returns the current time of the youtube player.
      #
      # @return Int The number of milliseconds we're into the video. Returns 0
      #             if there is some error getting the time.
      getCurrentTime = ->
        result = 0
        try
          result = ($youtube.player.getCurrentTime() * 1000) - $scope.offset
        finally
          return Math.max 0, result

      $scope.changeOffset = (delta) ->
        console.log 'NEW OFFSET YO'
        $scope.offset += delta

      $scope.$watch 'offset', () ->
        console.log 'offset was updated'

      # makes sure our lyrics are on-track. this is running every second
      # to deal with people fast-forwarding or rewinding. buffering and
      # whatnot gets handled already in listeners from queueTrack
      validator = (onetime = false) ->
        console.log 'validator running...'

        currentTime = getCurrentTime()
        if currentTime > $scope.lyrics[self.lyricIndex].time and
          $scope.lyrics[self.lyricIndex+1] != null and
          currentTime < $scope.lyrics[self.lyricIndex+1].time

            # everything's great!
        else
          # time is off!
          console.log 'validator says timing is off'
          console.log 'current time is ' + currentTime
          console.log 'last lyric timing was ' + $scope.lyrics[self.lyricIndex].time
          console.log 'next lyric timing was ' + $scope.lyrics[self.lyricIndex+1].time

          $timeout.cancel(timer)
          initLyric()

        validation = $timeout( validator, VALIDATION_CYCLE )


      # Call this if we're choosing a new video but don't want to change the
      # lyrics or anything.
      #
      # @param video Object The video object to load.
      # @return null
      $scope.selectVideo = (video) ->
        console.log 'selectVideo from KaraokeCtrl'
        $scope.code = video.youtube_id
        $scope.video = video
        initLyric()


    return null

]
