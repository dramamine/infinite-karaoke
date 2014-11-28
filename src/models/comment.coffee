mongoose = require 'mongoose'

CommentSchema = mongoose.Schema
  parent: String # ID of the thing this is a comment on
  type: Number
  rating: Number
  category: Number
  reason: String
  ip: String


module.exports = mongoose.model 'Comment', CommentSchema