Lyric = require '../models/lyric'

class LyricApi
  constructor: (@app) ->

    @app.get '/lyric/:_id', @getLyric
    @app.post '/lyric', @createLyric

  getLyric: (req, res) ->
    {_id} = req.params
    return Lyric.findOne {track: _id}, (err, lyric) ->
      if err
        console.log err
        return res.send 400, err
      if lyric == null
        return res.send 204

      res.json lyric

  createLyric: (req, res) ->
    res.send 501, "Not implemented yet"


module.exports = (app) -> new LyricApi app