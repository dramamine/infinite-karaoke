
angular.module('karaoke.display').controller 'KaraokeCtrl', [
  '$scope', '$rootScope', '$resource', '$youtube', '$timeout', '$log',
  ($scope, $rootScope, $resource, $youtube, $timeout, $log) ->

    # used for the CSS 'progress bar'. basically, we swap the class to
    # 'inactive' for this many milliseconds, before swapping to 'active' with
    # the transition.
    # ...
    # Also using this for new CSS animations

    CSS_TRANSITION_MS = 50

    # if video loads before lyrics, we have to wait for them. (in ms)
    LYRIC_WAITING_CYCLE = 250

    # how often the validator runs
    VALIDATION_CYCLE = 5000

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
        $log.info 'API: video received.', result

        $scope.code = result.youtube_id
        $scope.video = result

        $scope.$emit 'playVideo'

        # autoplay
        $scope.$on 'youtube.player.ready', () ->
          $log.info 'YouTube: ready msg received'
          $youtube.player.playVideo()

        $scope.$on 'youtube.player.paused', () ->
          $log.info 'YouTube: paused msg received'
          $timeout.cancel(timer)
          $timeout.cancel(validation)

        $scope.$on 'youtube.player.playing', () ->
          $log.info 'YouTube: playing msg received'
          waitForLyrics()
          validation = $timeout( validator, VALIDATION_CYCLE )


      lyricApiCall = $resource('/lyric/' + newId)
      lyricApiCall.get {}, (result) ->
        $log.info 'API: lyric received.', result

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
            lyricAnimations()

            return null

        return null


      # update to the next lyric
      updateLyric = ->
        return null

        # usually called via $timeout, needs outside reference
        lyrics = $scope.lyrics
        self.lyricIndex++

        if lyrics[self.lyricIndex] != null
          $scope.currentLyric = lyrics[self.lyricIndex].line
        else
          $log.error 'UpdateLyric: Uh oh. couldn\'t find lyrics here:' + self.lyricIndex


        if lyrics[self.lyricIndex+1] != null
          # time to wait before showing the next lyric
          wait = lyrics[self.lyricIndex+1].time - getCurrentTime() - CSS_TRANSITION_MS

          if wait < 0
            $log.error 'UpdateLyric: wait was ' + wait + ' (must be >0)'
            wait = 0

          $log.info 'UpdateLyric: waiting ' + wait + ' for next update'
          timer = $timeout( updateLyric, wait )

          lyricAnimations()


        return null


      # call this function on updating lyricIndex
      lyricAnimations = ->
        console.log 'lyric animation called with index ' + self.lyricIndex
        if $scope.lyrics[self.lyricIndex-1]
          $scope.lyrics[self.lyricIndex-1].action = "exittop"
        if $scope.lyrics[self.lyricIndex]
          console.log 'enter topping the first lyric'
          $scope.lyrics[self.lyricIndex].action = "entertop"
        if $scope.lyrics[self.lyricIndex+1]
          $scope.lyrics[self.lyricIndex+1].action = "enterbottom"

      # clear out all animations. (tl;dr hides them all)
      clearAnimations = ->
        if $scope.lyrics[self.lyricIndex-1]
          $scope.lyrics[self.lyricIndex-1].action = null
        if $scope.lyrics[self.lyricIndex]
          $scope.lyrics[self.lyricIndex].action = null
        if $scope.lyrics[self.lyricIndex+1]
          $scope.lyrics[self.lyricIndex+1].action = null


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

      # Updates offset, like if user uses offset control
      $scope.changeOffset = (delta) ->
        console.log 'NEW OFFSET YO'
        $scope.offset += delta

      # makes sure our lyrics are on-track. this is running every second
      # to deal with people fast-forwarding or rewinding. buffering and
      # whatnot gets handled already in listeners from queueTrack
      validator = (onetime = false) ->


        currentTime = getCurrentTime()
        if $scope.lyrics[self.lyricIndex+1] and
          currentTime > $scope.lyrics[self.lyricIndex].time and
          currentTime < $scope.lyrics[self.lyricIndex+1].time

            # everything's great!
        else
          # time is off!
          console.log 'validator says timing is off'
          console.log 'current time is ' + currentTime
          console.log 'last lyric timing was ' + $scope.lyrics[self.lyricIndex].time
          console.log 'next lyric timing was ' + $scope.lyrics[self.lyricIndex+1].time

          $timeout.cancel(timer)
          clearAnimations()
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
