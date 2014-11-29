angular.module('karaoke.services').service 'DataService',
['$resource', '$q', '$http', ($resource, $q, $http) ->


  obj =
    # enums.
    # these are for comment types. if touching these, check out
    # the comments model
    TYPE_VIDEO: 0
    TYPE_LYRIC: 1
    FEEDBACK_OPTIONS: [
      {rating: -1, category: 1, text: 'Not the official music video' }
      {rating: -1, category: 2, text: 'Better video available' }
      {rating: -1, category: 3, text: 'Wrong song' }
      {rating: -5, category: 4, text: 'SHADOWBANNED' }
    ]

    getTrackList: () ->
      self = this
      deferred = $q.defer()

      url = "/track"
      resource = $resource(url)
      resource.query {}, (result) ->

        # convert to menu-items
        # TODO probs shouldn't do this in the controller, but whatever.
        angular.forEach result, (track) ->
          # use the label since this gets indexed
          track.label = track.artist + " - " + track.title
          track.value = track._id

          # temporarily needed for old entries
          # self.refreshQuality(track)# unless track.quality

          track.vidQualityCSS = switch track.quality.video
            when 2 then "color:gold"
            when 1 then "color:silver"
            else "display:none"

          track.lyricQualityCSS = switch track.quality.lyric
            when 2 then "color:gold"
            when 1 then "color:silver"
            else "display:none"

          track.popularCSS = switch track.quality.popular
            when true then "color:gold"
            else "display:none"

          # track.vidQualityCSS = "color:silver"

        deferred.resolve result

      return deferred.promise

    submitFeedback: (id, rating, category, type) ->
      url = '/video/comment/' + id
      $http.post(url, {
        rating: rating
        category: category
        type: type
      }).success( (data, status, headers, config) ->
        console.log 'success!'
        console.log data
      ).error( (data, status, headers, config) ->
        console.log 'fucked!'
        console.log data
      )

    getVideos: (trackid) ->
      deferred = $q.defer()

      url = 'videos/' + trackid
      $http.get(url).success( (data, status, headers, config) ->
        console.log 'got all the vids'
        deferred.resolve data
      ).error( (data, status, headers, config) ->
        console.log 'fucked!'
        console.log data
        deferred.reject data
      )

      return deferred.promise

    # private functions
    # refreshQuality: (track) ->
    #   console.log 'refreshQuality called.'

    #   # temporarily needed for old entries
    #   track.quality =
    #     video: 0
    #     lyric: 2
    #     popular: false
    #   if track.artist == "Tool"
    #     track.quality.popular = true

    #   origQuality = track.quality.video

    #   bestVid = _.max track.videos, (video) ->
    #     return video.score

    #   if bestVid.score > 0
    #     track.quality.video = 2
    #   else if bestVid.score == 0
    #     track.quality.video = 1
    #   else
    #     track.quality.video = 0

    #   unless track.quality.video == origQuality
    #     url = "/api/track/" + track._id
    #     console.log url
    #     #trackid = track._id
    #     resource = $resource url

    #     resource.save track, () ->
    #       console.log 'track updated...?'
    #       console.log track

    #   return track

  return obj
]