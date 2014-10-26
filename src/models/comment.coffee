mongoose = require 'mongoose'

CommentSchema = mongoose.Schema
  parent: String # ID of the thing this is a comment on
  # might want type in here...
  rating: Number
  category: Number
  reason: String
  ip: String


module.exports = mongoose.model 'Comment', CommentSchema