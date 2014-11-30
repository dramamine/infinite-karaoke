Video = require '../models/video'
Lyric = require '../models/lyric'
Track = require '../models/track'
_ = require 'underscore-node'

Helper = require '../lib/helper'
q = require 'q'

class TrackApi
  constructor: (@app) ->

    self = this

    @app.get '/track', @getTracks
    @app.get '/track/:_id', @getTrack
    @app.post '/track/:_id', @updateTrack
    @app.get '/search/:phrase', @search

    @app.get '/keywords', @updateAllKeywords


  getTracks: (req, res, next) ->
    Track.find req.query, (err, docs) ->
      return res.send 500, err if err
      res.json docs

  getTrack: (req, res) ->
    {_id} = req.params
    Track.findOne {_id}, (err, track) ->
      return res.send 500, err if err
      return res.send 404 if track == null
      res.json track



  updateTrack: (req, res, next) ->
    {_id} = req.params
    # console.log req.body

    return Track.findById _id, (err, track) ->
      if !track
        res.send 404

      # only updating quality for now
      if !track.quality
        console.log 'updating quality...'
        promise = Helper.updateTrackQuality track
        promise.then (track) ->
          console.log 'got promise back! returning my track now.'
          res.send track



      # do nothing
      return track.save (err) ->
        console.log 'tried to save a thing.'
        console.log err if err
        if err then res.send err, 400
        else res.send 200

  search: (req, res, next) ->

    {phrase} = req.params
    Track.find { $text: { $search: phrase } },
      { score: { $meta: 'textScore' }, keywords: 0, __v: 0 }
    .sort { score: { $meta: 'textScore' } }
    .limit 5
    .exec (err, tracks) ->
      if err
        console.log err
        return res.send err, 400

      promise = addThumbnails(tracks).then (results) ->
        return res.json results, 200






  # untested, unused function to add keywords!
  #
  # updateKeywords: (req, res, next) ->
  #   {_id} = req.params
  #   Track.findById _id, (err, track) ->

  #     if track.keywords == []
  #       console.log track
  #       return res.send 'Already has keywords'

  #     track.keywords = Helper.getKeywords track

  #     console.log track
  #     track.save (err) ->
  #       console.log 'tried to save a thing.'
  #       console.log err if err
  #       if err then res.send err, 400
  #       else res.send 200

  # adds keywords to ALL THE TRACKS
  updateAllKeywords: (req, res, next) ->
    Track.find {}, (err, tracks) ->
      for track in tracks
        if track.keywords == []
          console.log track.artist + track.title ' already has keywords'
          continue

        track.keywords = Helper.getKeywords track

        console.log track.artist + track.title
        console.log track.keywords.join(' ')
        track.save (err) ->
          console.log err if err


addThumbnails = (tracks) ->
  deferred = q.defer()

  results = []
  for track in tracks
    Video.findOne {track: track._id }
    .sort { score: -1 }
    .exec (err, video) ->
      if err
        console.log err
        promise.reject

      if video == null
        console.log 'no results for ' + track._id
        return

      mytrack = _.find tracks, (track) ->
        return (String(track._id) == video.track)

      newinfo =
        _id: mytrack._id
        artist: mytrack.artist
        title: mytrack.title
        quality: mytrack.quality
        tags: mytrack.tags
        thumbnail: video.thumbnail
      results.push newinfo

      if results.length == tracks.length
        console.log 'using results:'
        console.log results
        return deferred.resolve results

  return deferred.promise

module.exports = (app) -> new TrackApi app