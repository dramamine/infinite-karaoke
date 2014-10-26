mongoose = require 'mongoose'

VideoSchema = mongoose.Schema
  track: String # ID linking to a track
  youtube_id: String
  title: String
  description: String
  published: String
  thumbnail: String
  score: Number
  # patches: [{}]
  # offset: Number

  best: Boolean

module.exports = mongoose.model 'Video', VideoSchema