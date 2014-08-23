'use strict'

# Controllers

allControllers = angular.module('allControllers', ['allServices'])

# used to track application state
allControllers.controller 'StateCtrl', ['$scope',
  ($scope) ->
    $scope.hasSearched = false
    $scope.trackid = null

    $scope.userAddedTrackId = null

    return null
]

allControllers.controller 'TrackSearchCtrl', ['$scope', '$resource', 'TrackService', 
  ($scope, $resource, TrackService) -> 
    $scope.myData = {}
    # load placeholder data
    $scope.tracks = TrackService.data
    $scope.myData.tracks = TrackService.data
    $scope.selectedTrack = {}
    #$scope.myData.selectedTrack = 'Test - Test'


    $scope.pickTrack = ->
      console.log "pickTrack called."
      console.log $scope.selectedTrack.value

      $scope.$parent.trackid = $scope.selectedTrack.value
      $scope.userAddedTrackId = $scope.selectedTrack.value
      $scope.$parent.hasSearched = true

      


    # not a router, I swear.
    # This is kinda dirty, since "selectedTrack" is either a JSON object with
    # track data, or just the text that the user entered.
    $scope.pickUrl = ->
      if $scope.selectedTrack.value
        # LOL HAX
        # JUST LOAD THE OLD VERSION OF THE PAGE
        # it uses jQuery and all this shit
        # I could write a new directive...some day.
        # 
        # return '#/track/' + $scope.selectedTrack.value
        return '/karaoke/' + $scope.selectedTrack.value
      return '#/search/' + $scope.selectedTrack



    # get tracks from the database
    # @see routes/api.coffee
    url = "/api/track"
    resource = $resource(url)
    resource.query {}, (result) ->

      # convert to menu-items
      # TODO probs shouldn't do this in the controller, but whatever.
      angular.forEach result, (track) ->
        # TODO use formatForDropdown insteadls
        track.label = "#{track.artist} - #{track.title}"
        track.value = track._id

      $scope.tracks = result

      console.log result

    return null

]

allControllers.controller 'PlayCtrl', ['$scope', '$resource', '$youtube',
  '$timeout', ($scope, $resource, $youtube, $timeout) -> 

    currentTime = 0
    lyrics = []
    lyricIndex = 0
    timer = null

    self = this

    $scope.currentLyric = ''

    # $scope.code = 'oHg5SJYRHA0'
    $scope.trackData = {}

    $scope.queueTrack = (newId) ->
      console.log 
      console.log "queueTrack called. querying this ID:" + newId
      url = "/api/track"
      resource = $resource(url)
      resource.query { _id: newId }, (result) ->

        # TODO do I need all this?
        $scope.trackData = result[0]
        self.lyrics = $scope.trackData.lyrics[0].content

        # TODO this is pretty shitty for now, but can fix this up when we add
        # better support for choosing a video.
        $scope.code = result[0].videos[0].youtube_id


        # autoplay
        $scope.$on 'youtube.player.ready', () ->
          $youtube.player.playVideo()

        $scope.$on 'youtube.player.paused', () ->
          console.log "Cancelling timer."
          $timeout.cancel(timer)

        $scope.$on 'youtube.player.playing', () ->
          console.log "Video's playing."

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


        console.log "Update lyric called."
        self.lyricIndex++
        $scope.currentLyric = lyrics[self.lyricIndex].line
        console.log "Updated lyric to " + lyrics[self.lyricIndex].line
        console.log lyrics[self.lyricIndex]
        console.log lyrics[self.lyricIndex + 1]
        wait = lyrics[self.lyricIndex + 1].time - lyrics[self.lyricIndex].time
        console.log "Waiting " + wait + " to update again."
        timer = $timeout( updateLyric, wait )

        return null


      getCurrentTime = ->
        return $youtube.player.getCurrentTime() * 1000




    return null

]