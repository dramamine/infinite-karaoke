mongoose = require 'mongoose'

VideoSchema = mongoose.Schema
  youtube_id: String
  title: String
  description: String
  published: String
  thumbnail: String
  score: Number
  comments: [
    rating: Number
    category: Number
    reason: String
    ip: String
  ]
  patches: [{}]
  offset: Number

module.exports = mongoose.model 'Video', VideoSchema