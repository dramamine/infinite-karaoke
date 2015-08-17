Video = require '../models/video'
Lyric = require '../models/lyric'
Track = require '../models/track'
Comment = require '../models/comment'
_ = require 'underscore-node'

class CommentApi
  constructor: (@app) ->

    @app.post '/video/comment/:_id', @addVideoFeedback

  addVideoFeedback: (req, res, next) ->

    {_id} = req.params
    console.log 'looking for ' + _id

    return Video.findById _id, (err, video) ->
      if !video
        console.log 'Just couldnt find that video.'
        return res.send 406, err

      newcomment = new Comment

      console.log req.body
      console.log typeof req.body.rating
      console.log typeof req.body.category
      console.log typeof req.body.type
      #console.log req.body.comment?

      if !req.body? or
      !req.body.rating? or
      !req.body.category? or
      !req.body.type?
        console.log 'Missing some shit.'
        res.send 500, 'Missing some critical shit.'
        return

      if (typeof req.body.rating == "number" and
      req.body.rating >= -1 and
      req.body.rating <= 1)
        newcomment.rating = req.body.rating
      else
        console.log 'Rating not valid.'
        res.send 500, 'Rating not valid.'

      if typeof req.body.category == "number" and
      req.body.category >= 0
        newcomment.category = req.body.category
      else
        console.log 'Category not valid.'
        res.send 500, 'Category not valid.'

      if typeof req.body.type == "number"
        newcomment.type = req.body.type
      else
        console.log 'Type not valid.'
        res.send 500, 'Type not valid.'

      if req.body.reason and
      typeof req.body.reason == "string"
        newcomment.reason = req.body.reason

      if typeof req.ip == "string"
        console.log 'checking IP ' + req.ip
        # match = _.find(video.comments, (comment) -> comment.ip == req.ip )
        # console.log match

        # figure the above shit out later.
        newcomment.ip = req.ip

      newcomment.save (err, comment) ->
        if err
          console.error err
          res.send 500, 'DB error.'
        else
          res.send 200
      # Video.update(
      #   {_id: _id}
      #   $push: {comments: newcomment}
      #   (err, comment) ->
      #     if err
      #       console.log err
      #       res.send 501
      #     else
      #       console.log comment
      #       res.send 200
      # )




      #     newcomment.reason = req.body.comment.reason
      # else
      #   res.send 300, 'Reason not valid.'


    # console.log 'got an updateTrack call.'
    # req.track = req.body
    # console.log req.body
    # req.track.save (err, success) ->
    #   console.log 'saved a thing.'
    #   console.log err
    #   if err then res.send err, 400
    #   else res.send 200


module.exports = (app) -> new CommentApi app