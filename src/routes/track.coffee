Video = require '../models/video'
Lyric = require '../models/lyric'
Track = require '../models/track'
_ = require 'underscore-node'

Helper = require '../lib/helper'
q = require 'q'

class TrackApi
  constructor: (@app) ->

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
    return res.send 'Not ready', 401

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


module.exports = (app) -> new TrackApi app