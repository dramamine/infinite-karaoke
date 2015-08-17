Video = require '../models/video'
Lyric = require '../models/lyric'
Track = require '../models/track'
_ = require 'underscore-node'

class VideoApi
  constructor: (@app) ->

    @app.get '/video/:_id', @getBestVideo
    @app.get '/video/promote/:_id', @promoteVideo
    @app.get '/video/demote/:_id', @demoteVideo
    @app.get '/videos/:_id', @getVideos
    @app.post '/video', @createVideo



  getBestVideo: (req, res) ->

    # shittily putting this here until I figure out accessing
    # class members inside callbacks
    _maintainBestVideo = (videos) ->
      newBestVid = _.max videos, (video) ->
        return video.score

      Video.find {best: true}, (err, videos) ->
        for video in videos
          if video != newBestVid
            video.best = false
            video.save()
          else
            console.log 'found the same best video.'

      newBestVid.best = true
      newBestVid.save()

      return newBestVid


    console.log 'best vid called.'
    {_id} = req.params
    Video.findOne {track: _id, best: true}, (err, video) ->
      if err
        console.log 'got an error trying to find one.'
      if video == null
        # it's okay, just make one the best!
        Video.find {track: _id}, (err, videos) ->
          # return the thing we made the new best video.
          res.json _maintainBestVideo videos
      else
        res.json video


  getVideos: (req, res) ->
    {_id} = req.params
    return Video.find {track: _id}, (err, videos) ->
      if err
        console.log err
        res.send 400, err
      res.json videos

  promoteVideo: (req, res) ->
    {_id} = req.params


    Video.findById _id, (err, video) ->

      # the one that was best? not anymore.
      Video.findOne {track: video.track, best: true}, (err, besties) ->
        if err
          console.log 'got an error trying to find the current best video for ', video.track
          return
        besties.best = false
        return besties.save()

      # promote our guy
      video.score = video.score+10
      video.best = true
      video.save()
      res.json video

  demoteVideo: (req, res) ->
    {_id} = req.params
    Video.findById _id, (err, video) ->
      video.score = video.score-10
      video.best = false
      video.save()
      res.send 200, 'Success'

  createVideo: (req, res) ->
    res.send 400, 'Not implemented yet'



module.exports = (app) -> new VideoApi app