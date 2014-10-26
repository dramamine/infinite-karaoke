Video = require '../models/video'
Lyric = require '../models/lyric'
Track = require '../models/track'
_ = require 'underscore-node'

class TrackApi
  constructor: (@app) ->

    @app.get '/track', @getTracks
    @app.get '/track/:_id', @getTrack
    @app.post '/track/:_id', @updateTrack


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
      if req.body.quality
        track.quality = req.body.quality

      # do nothing
      return track.save (err) ->
        console.log 'tried to save a thing.'
        console.log err if err
        if err then res.send err, 400
        else res.send 200

module.exports = (app) -> new TrackApi app