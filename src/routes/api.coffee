Video = require '../models/video'
Lyric = require '../models/lyric'
Track = require '../models/track'

class Api
  constructor: (@app) ->

    @app.get '/api/track', @getTracks

  
  getTracks: (req, res, next) ->
    Track.find req.query, (err, docs) ->
      return res.send 500, err if err
      res.json docs 

module.exports = (app) -> new Api app