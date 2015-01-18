angular.module('karaoke.data').service 'DataService',
['$resource', '$q', '$http', '$log', ($resource, $q, $http, $log) ->

  addQualityCSS = (track) ->

    track.vidQualityCSS = switch track.quality.video
      when 2 then 'color:gold'
      when 1 then 'color:silver'
      else 'display:none'

    track.lyricQualityCSS = switch track.quality.lyric
      when 2 then 'color:gold'
      when 1 then 'color:silver'
      else 'display:none'

    track.popularCSS = switch track.quality.popular
      when true then 'color:gold'
      else 'display:none'

    return track

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

    # Retrieves the track list, formats some CSS for displaying as search
    # results. Right now, this is 'dumb' and just retrieves every track.
    getTrackList: () ->
      # do I need this line?
      self = this
      deferred = $q.defer()

      url = '/track'
      resource = $resource(url)
      resource.query {}, (result) ->

        # convert to menu-items
        # TODO probs shouldn't do this in the controller, but whatever.
        angular.forEach result, (track) ->
          # use the label since this gets indexed
          track = addQualityCSS(track)

          # track.vidQualityCSS = "color:silver"

        deferred.resolve result

      return deferred.promise

    # Submits feedback from the user.
    #
    # @param id String The ID on which we're giving feedback (ex. video ID,
    #                  lyric ID).
    # @param rating Int The rating to give.
    # @param category Int The category ID.
    # @param type Int The comment type (ex. TYPE_VIDEO).
    submitFeedback: (id, rating, category, type) ->
      deferred = $q.defer()
      url = '/video/comment/' + id
      $http.post(url, {
        rating: rating
        category: category
        type: type
      }).success( (data, status, headers, config) ->
        $log.info 'success!'
        $log.info data
        deferred.resolve data
      ).error( (data, status, headers, config) ->
        $log.error 'something went wrong with submitting feedback.'
        $log.error data
        deferred.reject data
      )
      return deferred.promise

    # Retrieves all videos in the database for a given track ID.
    #
    # @param trackid String The track ID.
    # @return a promise, which resolves to an array of video objects
    getVideos: (trackid) ->
      deferred = $q.defer()

      url = 'videos/' + trackid
      $http.get(url).success( (data, status, headers, config) ->
        deferred.resolve data
      ).error( (data, status, headers, config) ->
        $log.error 'error when trying to get videos.'
        $log.error data
        deferred.reject data
      )

      return deferred.promise

    searchFor: (terms, page = 0) ->
      deferred = $q.defer()

      if terms.match(/[a-zA-Z0-9]+/)
        url = 'search/' + terms
      else # use default search
        url = 'search'
      if page > 0
        url += '/page/' + page

      $http.get(url).success( (data, status, headers, config) ->

        angular.forEach data, (track) ->
          track = addQualityCSS(track)

        deferred.resolve data
      ).error( (data, status, headers, config) ->
        $log.error 'error when trying to run a search.'
        $log.error data
        deferred.reject data
      )

      return deferred.promise



  return obj
]