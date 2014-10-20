Video = require '../models/video'
Lyric = require '../models/lyric'
Track = require '../models/track'

class Api
  constructor: (@app) ->

    @app.get '/api/track', @getTracks
    @app.get '/api/track/:_id', @getTrack
    @app.post '/api/track/:_id', @updateTrack

  
  getTracks: (req, res, next) ->
    Track.find req.query, (err, docs) ->
      return res.send 500, err if err
      res.json docs 

  getTrack: (req, res) ->
      {_id} = req.params
      Track.findOne {_id}, (err, track) ->
        return res.send 500, err if err
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

    # console.log 'got an updateTrack call.'
    # req.track = req.body
    # console.log req.body
    # req.track.save (err, success) ->
    #   console.log 'saved a thing.'
    #   console.log err
    #   if err then res.send err, 400
    #   else res.send 200


module.exports = (app) -> new Api app