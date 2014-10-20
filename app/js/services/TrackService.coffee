angular.module('karaoke.services').service 'TrackService', ['$resource', '$q', ($resource, $q) ->
  




  obj = 

    getTrackList: () ->
      self = this
      deferred = $q.defer()

      url = "/api/track"
      resource = $resource(url)
      resource.query {}, (result) ->

        # convert to menu-items
        # TODO probs shouldn't do this in the controller, but whatever.
        angular.forEach result, (track) ->
          # use the label since this gets indexed
          track.label = track.artist + " - " + track.title
          track.value = track._id

          self.refreshQuality(track)
          # TODO placeholder for now
          track.vidQualityCSS = "color:silver"

        deferred.resolve result

      return deferred.promise

    # private functions
    refreshQuality: (track) ->
      console.log 'refreshQuality called.'

      # temporarily needed for old entries
      unless track.quality
        track.quality = 
          video: 0
          lyric: 0

      origQuality = track.quality.video
      
      bestVid = _.max track.videos, (video) -> 
        return video.score

      if bestVid.score > 0
        track.quality.video = 2
      else if bestVid.score == 0
        track.quality.video = 1
      else
        track.quality.video = 0

      unless track.quality.video == origQuality
        url = "/api/track/" + track._id
        console.log url
        #trackid = track._id
        resource = $resource url
        
        resource.save track, () ->
          console.log 'track updated...?'
          console.log track

      return track

  return obj
]