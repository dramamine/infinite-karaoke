
angular.module('karaoke.controllers').controller 'KaraokeCtrl', [
  '$scope', '$resource', '$youtube', '$timeout',
  ($scope, $resource, $youtube, $timeout) ->

    # used for the CSS 'progress bar'. basically, we swap the class to
    # 'inactive' for this many milliseconds, before swapping to 'active' with
    # the transition.
    CSS_TRANSITION_MS = 20

    currentTime = 0
    lyrics = []
    lyricIndex = 0
    timer = null
    video = null

    # used for the 'progress bar' tracker
    $scope.tracker =
      class: 'lyricbox-inactive'
      style: {}

    self = this

    # current lyric being displayed
    $scope.currentLyric = ''

    $scope.queueTrack = (newId) ->
      console.log "queueTrack called. querying this ID:" + newId


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

        $scope.$on 'youtube.player.playing', () ->
          console.log "Video's playing."

      lyricApiCall = $resource('/lyric/' + newId)
      lyricApiCall.get {}, (result) ->
        console.log 'lyric received.'
        console.log result

        self.lyrics = result.content
        initLyric()

      initLyric = ->
        # usually called via $on, needs outside reference
        lyrics = self.lyrics
        # lyricIndex = self.lyricIndex

        console.log "Init lyric called."

        currentTime = getCurrentTime()
        console.error "Weird current time." unless currentTime >= 0

        for lyric, idx in lyrics
          console.log "initLyric: idx" + idx + ", lyric " + lyric
          # find the lyric which comes right after the current time
          console.log "examining " + lyric.time + " vs. current time " + currentTime
          if lyric.time > currentTime
            self.lyricIndex = idx - 1
            console.log "Setting current index to " + self.lyricIndex
            $scope.currentLyric = lyrics[self.lyricIndex].line

            wait = (lyric.time - currentTime)
            timer = $timeout( updateLyric, wait )

            console.log "Waiting " + wait + " to change lyric."

            return null

        return null


      updateLyric = ->
        # usually called via $timeout, needs outside reference
        lyrics = self.lyrics
        self.lyricIndex++
        $scope.currentLyric = lyrics[self.lyricIndex].line
        # console.log "Updated lyric to " + lyrics[self.lyricIndex].line
        # console.log lyrics[self.lyricIndex]
        # console.log lyrics[self.lyricIndex + 1]


        if lyrics[self.lyricIndex+1] != null
          # time to wait before showing the next lyric
          wait = lyrics[self.lyricIndex + 1].time - lyrics[self.lyricIndex].time
          timer = $timeout( updateLyric, wait )
          # console.log "Waiting " + wait + " to update again."

          updateProgressBar(wait)

        return null

      updateProgressBar = (wait) ->
        $scope.tracker =
          class: 'lyricbox-inactive'
          style: {}

        $scope.$apply()

        # how long is our wait?
        seconds = Math.floor (wait-CSS_TRANSITION_MS)/100 # now it's tenths of a second
        seconds = seconds/10

        $timeout () ->
          $scope.tracker =
            class: 'lyricbox-active'
            style: getTransitionCSS(seconds)
          return null
        , CSS_TRANSITION_MS

        $scope.$apply()

      getTransitionCSS = (seconds) ->
        console.log 'using ' + seconds + ' as my seconds'
        return {
          '-webkit-transition': 'width ' + seconds + 's linear'
          '-moz-transition': 'width ' + seconds + 's linear'
          '-o-transition': 'width ' + seconds + 's linear'
          '-ms-transition': 'width ' + seconds + 's linear'
          'transition': 'width ' + seconds + 's linear'
        }

      getCurrentTime = ->
        result = 0
        try
          result = $youtube.player.getCurrentTime() * 1000
        finally
          return result

      $scope.selectVideo = (video) ->
        console.log 'selectVideo from KaraokeCtrl'
        $scope.code = video.youtube_id
        $scope.video = video
        initLyric()



    return null

]
