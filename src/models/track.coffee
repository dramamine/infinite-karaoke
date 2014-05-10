mongoose = require 'mongoose'
Video = require './video'
Lyric = require './lyric'

TrackSchema = mongoose.Schema
  artist: String
  track: String
  lyric: [Lyric.schema]
  video: [Video.schema]
  tags: [String]

# turn tags into searchable item
TrackSchema.methods.allTags = ->
  return "#" + tags.all.join(' #')

TrackSchema.methods.formatForDropdown = ->
  return "#{artist} - #{track}"

module.exports = mongoose.model 'Track', TrackSchema