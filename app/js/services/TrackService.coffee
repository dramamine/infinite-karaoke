angular.module('karaoke.services').service 'TrackService', ['$resource', '$q', ($resource, $q) ->
  obj = 

    getTrackList: () ->
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

          # TODO placeholder for now
          track.vidQualityCSS = "color:silver"

        deferred.resolve result

      return deferred.promise

  return obj
]