mongoose = require 'mongoose'

VideoSchema = mongoose.Schema
  youtube_id: String
  comments: [
    rating: Number
    category: Number
    reason: String
    ip: String
  ]
  patches: [{}]
  offset: Number

module.exports = mongoose.model 'Video', VideoSchema