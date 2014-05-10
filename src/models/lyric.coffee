mongoose = require 'mongoose'

LyricSchema = mongoose.Schema
  comments: [
    rating: Number
    category: Number
    reason: String
    ip: String
  ]
  content: [{ time: Number, line: String } ]
  patches: [{}]
  imported: Boolean

module.exports = mongoose.model 'Lyric', LyricSchema