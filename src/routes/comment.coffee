Video = require '../models/video'
Lyric = require '../models/lyric'
Track = require '../models/track'
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
        res.send 406, err

      console.log req.body
      console.log typeof req.body.comment.rating
      console.log typeof req.body.comment.category
      console.log typeof req.body.comment.reason
      #console.log req.body.comment?

      if !req.body.comment? or
        !req.body.comment.rating? or
        !req.body.comment.category? or
        !req.body.comment.reason?
          console.log 'Missing some shit.'
          res.send 500, 'Missing some critical shit.'
          return

      newcomment = {}
      if (typeof req.body.comment.rating == "number" and
        req.body.comment.rating >= -1 and
        req.body.comment.rating <= 1)

          newcomment.rating = req.body.comment.rating
      else
        console.log 'Rating not valid.'
        res.send 500, 'Rating not valid.'

      if typeof req.body.comment.category == "number" and
        req.body.comment.category >= 0
          newcomment.category = req.body.comment.category
      else
        console.log 'Category not valid.'
        res.send 500, 'Category not valid.'

      if typeof req.body.comment.reason == "string"
        newcomment.reason = req.body.comment.reason
      else
        console.log 'Reason not valid.'
        res.send 500, 'Reason not valid.'

      if typeof req.body.comment.ip == "string"
        match = _.find(video.comments, (comment) -> comment.ip == req.body.comment.ip )
        console.log "matching IP?"
        console.log match

        # figure the above shit out later.
        newcomment.ip = req.body.comment.ip

        video.comments.push(newcomment)
        video.save()
        console.log video
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