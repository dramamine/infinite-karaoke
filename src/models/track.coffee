mongoose = require 'mongoose'
Video = require './video'
Lyric = require './lyric'

TrackSchema = mongoose.Schema
  artist: String
  title: String
  lyrics: [Lyric.schema]
  videos: [Video.schema]
  tags: [String]

# turn tags into searchable item
TrackSchema.methods.allTags = ->
  return "#" + tags.all.join(' #')

TrackSchema.methods.formatForDropdown = ->
  return "#{artist} - #{title}"

module.exports = mongoose.model 'Track', TrackSchema