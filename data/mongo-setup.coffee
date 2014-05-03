mongoose = require 'mongoose'
mongoose.connect 'mongodb://dbh36.mongolab.com:27367/infinite'

db = mongoose.connection
db.on 'error', console.error.bind(console, 'connection error:')
db.once 'open', ->
  console.log 'got a connection!'



LyricSchema = mongoose.Schema
  comments: 
    rating: Number
    category: Number
    reason: String
    ip: String
  content: [{ time: Number, line: String } ]
  history: [{ id: String }]

VideoSchema = mongoose.Schema
  youtube_id: String
  comments: 
    rating: Number
    category: Number
    reason: String
    ip: String
  history: [{id: String}]
  offset: Number

TrackSchema = mongoose.Schema
  artist: String
  track: String
  lyric: [LyricSchema]
  video: [VideoSchema]
  tags: [String]

# turn a
trackSchema.methods.allTags = ->
  return "#" + tags.all.join(' #')




trackSchema.methods.formatForDropdown = ->
  return "#{artist} - #{track}"

Track = mongoose.model 'Track', trackSchema

lyricSchema = mongoose.Schema
  _id : Number


lyricSchema.methods.comment_total = ->
  # 
  return 0

Lyric = mongoose.model 'Lyric', lyricSchema



lyricCommentSchema = mongoose.Schema






x = new Track({"artist":"Arcade Fire", "track": "Ready to Start"}).save()
x = new Track({"artist":"Black Kids", "track": "I'm Not Gonna Teach Your Boyfriend How To Dance With You"}).save()
x = new Track({"artist":"Bon Iver", "track": "Skinny Love"}).save()
x = new Track({"artist":"Chromeo", "track": "Fancy Footwork"}).save()
x = new Track({"artist":"Chvrches", "track": "Recover"}).save()
x = new Track({"artist":"Deftones", "track": "Change (In the House of Flies)"}).save()
x = new Track({"artist":"Foster The People", "track": "Pumped Up Kicks"}).save()
x = new Track({"artist":"Janelle Monae", "track": "Tightrope (featuring Big Boi)"}).save()
x = new Track({"artist":"Jimmy Eat World", "track": "Bleed American"}).save()
x = new Track({"artist": "Nine Inch Nails", "track": " We're In This Together"}).save()
x = new Track({"artist": "Nine Inch Nails", "track": "Head Like A Hole"}).save()
x = new Track({"artist": "Owl City", "track": "Deer in the Headlights"}).save()
x = new Track({"artist": "Radiohead", "track": "Karma Police"}).save()
x = new Track({"artist": "Rage Against the Machine", "track": "Killing In The Name"}).save()
x = new Track({"artist": "Refused", "track": "New Noise"}).save()
x = new Track({"artist": "Rich Boy", "track": "Throw Some D's"}).save()
x = new Track({"artist": "Taking Back Sunday", "track": "Great Romances Of The 20th Century"}).save()
x = new Track({"artist": "The Faint", "track": "Desperate Guys"}).save()
x = new Track({"artist": "The National", "track": "Bloodbuzz Ohio"}).save()
x = new Track({"artist": "The Postal Service", "track": "Such Great Heights"}).save()
x = new Track({"artist": "The Weeknd", "track": "Thursday"}).save()
x = new Track({"artist": "The XX", "track": "VCR"}).save()
x = new Track({"artist": "Thursday", "track": "Signals Over the Air"}).save()
x = new Track({"artist": "TV on the Radio", "track": "I Was A Lover"}).save()
x = new Track({"artist": "TV On The Radio", "track": "Will Do"}).save()
x = new Track({"artist": "Vampire Weekend", "track": "Giving Up The Gun"}).save()
x = new Track({"artist": "Wavves", "track": "King of the Beach"}).save()
x = new Track({"artist": "Yeasayer", "track": "Ambling Alp"}).save()
x = new Track({"artist": "Miley Cyrus", "track": "Party in the USA"}).save()
x = new Track({"artist": "The Joy Formidable", "track": "Whirring"}).save()
x = new Track({"artist": "Nicki Minaj", "track": "Beez in the Trap"}).save()

Track.find { artist: /The National/ }, (err, refuseds) ->
  console.log "found a thing"
  console.log refuseds