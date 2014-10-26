mongoose = require 'mongoose'

LyricSchema = mongoose.Schema
  track: String # ID linking to a track
  content: [{ time: Number, line: String } ]
  imported: Boolean

  # patches: [{}]

module.exports = mongoose.model 'Lyric', LyricSchema