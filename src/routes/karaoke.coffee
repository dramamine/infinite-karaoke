# CURRENTLY DEPRECATED
# This could be used to provide direct links to certain songs
# but isn't really being used now that I switched to a single-page app.

TrackModel = require '../models/track'

class Karaoke
  constructor: (@app) ->

    @app.get '/karaoke/:id', @karaoke

  karaoke: (req, res) ->

    console.log 'rendering karaoke class or something'
    {id} = req.params



    # TrackModel.findOne {_id: id}, (err, track) ->
    #   console.log track

      # how do I send this to the controller

    res.render 'youtube', {
      trackid: id
    }

module.exports = (app) -> new Karaoke app