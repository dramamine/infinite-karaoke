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
  title: String
  description: String
  published: String # actually is a timestamp
  thumbnail: String # is a URL
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
  title: String
  lyrics: [LyricSchema]
  videos: [VideoSchema]
  tags: [String]

# turn tags into searchable item
TrackSchema.methods.allTags = ->
  return "#" + tags.all.join(' #')

TrackSchema.methods.formatForDropdown = ->
  return "#{artist} - #{name}"

Track = mongoose.model('Track', TrackSchema)
Lyric = mongoose.model('Lyric', LyricSchema)
Video = mongoose.model('Video', VideoSchema)

module.exports = 
  Track: Track
  Lyric: Lyric
  Video: Video
