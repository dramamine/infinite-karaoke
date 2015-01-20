
angular.module('karaoke.display').controller 'KaraokeCtrl', [
  '$scope', '$rootScope', '$resource', '$youtube', '$timeout', '$log',
  ($scope, $rootScope, $resource, $youtube, $timeout, $log) ->

    # used for the CSS 'progress bar'. basically, we swap the class to
    # 'inactive' for this many milliseconds, before swapping to 'active' with
    # the transition.
    CSS_TRANSITION_MS = 20

    currentTime = 0
    lyrics = []
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

      unless data and typeof data.trackid == 'string'
        $log.error 'loadTrack called with bad params'
        $log.error typeof data.trackid
        $log.error data
        $log.error data.trackid
        $log.error evt
        return false

      $scope.queueTrack data.trackid



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
        console.log 'set scope.video...'

        # autoplay
        $scope.$on 'youtube.player.ready', () ->
          $youtube.player.playVideo()

        $scope.$on 'youtube.player.paused', () ->
          console.log "Cancelling timer."
          $timeout.cancel(timer)
          $timeout.cancel(validation)

        $scope.$on 'youtube.player.playing', () ->
          console.log "Video's playing."
          initLyric()
          validation = $timeout( validator, 1000 )


      lyricApiCall = $resource('/lyric/' + newId)
      lyricApiCall.get {}, (result) ->
        console.log 'lyric received.'
        console.log result

        self.lyrics = result.content



      # initializes the lyric control
      initLyric = ->
        # usually called via $on, needs outside reference
        lyrics = self.lyrics
        # lyricIndex = self.lyricIndex

        console.log "Init lyric called."

        currentTime = getCurrentTime()

        for lyric, idx in lyrics
          # find the lyric which comes right after the current time
          if lyric.time > currentTime
            self.lyricIndex = idx - 1
            # console.log "Setting current index to " + self.lyricIndex
            $scope.currentLyric = lyrics[self.lyricIndex].line

            wait = (lyric.time - currentTime)
            timer = $timeout( updateLyric, wait )
            updateProgressBar(wait)

            # console.log "Waiting " + wait + " to change lyric."

            return null

        return null

      # update to the next lyric
      updateLyric = ->
        # usually called via $timeout, needs outside reference
        lyrics = self.lyrics
        self.lyricIndex++

        if lyrics[self.lyricIndex] != null
          $scope.currentLyric = lyrics[self.lyricIndex].line
        else
          console.log 'Uh oh. couldn\'t find lyrics here:' + self.lyricIndex


        if lyrics[self.lyricIndex+1] != null
          # time to wait before showing the next lyric
          wait = lyrics[self.lyricIndex + 1].time - lyrics[self.lyricIndex].time
          timer = $timeout( updateLyric, wait )
          # console.log "Waiting " + wait + " to update again."

          updateProgressBar(wait)

        return null

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
        currentTime = getCurrentTime()
        if currentTime > self.lyrics[self.lyricIndex].time and
          self.lyrics[self.lyricIndex+1] != null and
          currentTime < self.lyrics[self.lyricIndex+1].time

            # everything's great!
        else
          # time is off!
          $timeout.cancel(timer)
          initLyric()

        validation = $timeout( validator, 1000 )


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
