Video = require '../models/video'
Lyric = require '../models/lyric'
Track = require '../models/track'
Comment = require '../models/comment'
_ = require 'underscore-node'
q = require 'q'

Helper =

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

  recalculateBest: (trackid) ->
    deferred = q.defer()

    Video.find {track: trackid}, (err, videos) ->

      # ack, should probably update everyone's score by looking at feedback
      # for consistency
      # this is REALLY IMPORTANT
      # but I'm not gonna do it now lol yolo
      console.log 'all matching videos:', videos
      newBestVid = _.max videos, (video) ->
        return video.score
      console.log 'my best vid looks like this:', newBestVid

      Video.find {track: trackid, best: true}, (err, videos) ->
        for video in videos
          if video != newBestVid
            video.best = false
            console.log('removing best from someone')
            video.save()
          else
            console.log 'found the same best video.'

      newBestVid.best = true
      newBestVid.save()
      deferred.resolve newBestVid
    return deferred.promise

  # adding some 'keywords' so that search works better!
  # basically we're grabbing every 'substring' of each word that we can
  # so that we can quickly search in an autocomplete/typeahead kinda style
  getKeywords: (track) ->
    source = track.artist + ' ' + track.title
    source = source.replace(/[^\w\s]|_/g, '').replace(/\s+/g, ' ').toLowerCase()

    return this.findKeywords source

  # Turn words into keywords!
  # By that, I mean, take each word in the input string and turn it into an
  # array of substrings, ex. 'dog' turns into ['d','o','g','do','og']. It does
  # not include the word itself. The array is deduped.
  #
  # @param input String A string of space-delimited words. Like a sentence.
  # @return Array An array of substrings.
  findKeywords: (input) ->
    # so much LANGUAGE SCIENCE
    skipwords = ['the']

    words = input.split(' ')
    substrings = []

    for word in words
      if _.contains skipwords, word
        continue

      # max length to check
      maxlength = word.length - 1

      if maxlength <= 0
        continue

      for ln in [1..maxlength]
        for start in [0..(word.length - ln)]
          substrings.push word.substr start, ln

    return _.uniq substrings

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