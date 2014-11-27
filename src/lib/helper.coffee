Video = require '../models/video'
Lyric = require '../models/lyric'
Track = require '../models/track'
_ = require 'underscore-node'
q = require 'q'

class Helper

  updateTrackQuality: (track) ->
    deferred = q.defer()

    promises = []

    promises.push @addVideoQuality track

    Q.all(promises).then () ->
      console.log 'got all my stuff back.'
      console.log track
      track.save()
      deferred.resolve track


    return deferred.promise


  addVideoQuality: (track) ->
    deferred = q.defer()

    Video.findOne {track_id: track._id, best: true}, (err, video) ->
      if err or !video
        deferred.fail

      if video.score > 0
        track.quality.video = 2
      if video.score = 0
        track.quality.video = 1
      else
        track.quality.video = 0

      deferred.resolve track


    return deferred.promise

  addLyricQuality: (track) ->
    deferred = q.defer()

    Lyric.findOne {track_id: track._id}, (err, lyric) ->
      if err or !lyric
        track.quality.lyric = 0
        deferred.resolve track

      track.quality.lyric = 2
      deferred.resolve track


    return deferred.promise

module.exports = Helper