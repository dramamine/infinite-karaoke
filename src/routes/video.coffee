Video = require '../models/video'
Lyric = require '../models/lyric'
Track = require '../models/track'
_ = require 'underscore-node'
YTAPI = require '../lib/ytapi'
Helper = require '../lib/helper'

class VideoApi
  constructor: (@app) ->

    @app.get '/video/:_id', @getBestVideo
    @app.get '/video/promote/:_id', @promoteVideo
    @app.get '/video/demote/:_id', @demoteVideo
    @app.get '/videos/:_id', @getVideos
    @app.post '/video/create', @createVideo

  getBestVideo: (req, res) ->

    console.log 'best vid called.'
    {_id} = req.params
    Video.findOne {track: _id, best: true}, (err, video) ->
      if err
        console.log 'got an error trying to find one.'
      if video == null
        # it's okay, just make one the best!
        Helper.recalculateBest(_id).then (result) ->
          console.log 'used helper to calculate the best'
          res.json result
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
        if besties
          besties.best = false
          return besties.save()
        return null

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
    trackid = req.body.trackid
    youtube_id = req.body.youtube_id

    YTAPI.lookup(youtube_id).then (item) ->
      console.log ' youtube result: ', item

      # make sure it doesn't already exist...
      Video.findOne {track: trackid, youtube_id: item.id}, (err, exists) ->
        # this is not really an error!
        if err
          console.log err
        if !exists
          video = new Video
            track: trackid
            youtube_id: item.id
            title: item.snippet.title
            description: item.snippet.description
            published: item.snippet.publishedAt
            thumbnail: item.snippet.thumbnails.default.url
            views: item.statistics.views
            upvotes: item.statistics.likeCount
            downvotes: item.statistics.dislikeCount
            score: 5

          video.save (err, vid) ->
            console.log err if err
            Helper.recalculateBest trackid

            res.send 200, 'Success'
          , (err) ->
            res.send 400, 'Server Error'
        else
          res.send 400, 'Already Exists'




module.exports = (app) -> new VideoApi app