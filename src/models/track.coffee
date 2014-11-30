mongoose = require 'mongoose'
Video = require './video'
Lyric = require './lyric'

TrackSchema = mongoose.Schema
  artist: String
  title: String
  quality: {
    video: Number
    lyric: Number
    popular: Boolean
  }
  tags: [String]
  keywords: [String]

# turn tags into searchable item
TrackSchema.methods.allTags = ->
  return "#" + tags.all.join(' #')

module.exports = mongoose.model 'Track', TrackSchema