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

TrackSchema = mongoose.Schema
  artist: String
  track: String
  lyric: [LyricSchema]
  video: [VideoSchema]
  tags: [String]

# turn tags into searchable item
TrackSchema.methods.allTags = ->
  return "#" + tags.all.join(' #')

TrackSchema.methods.formatForDropdown = ->
  return "#{artist} - #{track}"

Track = mongoose.model('Track', TrackSchema)
Lyric = mongoose.model('Lyric', LyricSchema)
Video = mongoose.model('Video', VideoSchema)

module.exports = 
  Track: Track
  Lyric: Lyric
  Video: Video
