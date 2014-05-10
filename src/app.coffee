express = require 'express'
#expose = require 'express-expose'
require 'coffee-script'
require 'jade'
tracks = require './tracks'
db = require './db'
path = require 'path'
harp = require 'harp'
# these get app.locals working some magic, I guess
util = require 'util'
tp = require 'tea-properties'
df = require 'dateformat'

app = express()
#console.log 'hello from app.coffee'

#app.configure ->
  #app.use '/public', express.static (__dirname + '/public')
 

# app.use express.static (__dirname + '/public')
# app.use express.static (__dirname + '/views/public')
# app.use express.static '/public', (__dirname + '/views/public')

app.configure ->

  app.set 'view engine', 'jade'
  app.locals.pretty = true

  # connect to our db
  mongoose = require './db/db.coffee'

  # put everything you 'use' in here!
  middleware = [

  ]

  app.use m for m in middleware

  #probs don't need this line
  #app.use express.static path.join __dirname, '../public'
  #app.use express.static path.join __dirname, '../app'
  
  app.use '/', express.static path.resolve __dirname, '../public'
  app.use '/', harp.mount path.resolve __dirname, '../public'
  #app.use '/public', harp.mount path.resolve __dirname, '../public'
  app.use 'favicon', path.resolve __dirname, '../public/favicon.ico'


  app.locals
    get: (obj, loc, def = undefined) -> tp.get(obj, loc) ? def
    inspect: util.inspect
    df: df



# app.listen 666
# console.log 'Listening on port 666'


app.configure 'development', ->
  app.use express.errorHandler {dumpExceptions: true, showStack: true}
  app.locals.pretty = true
  app.set 'domain', 'localhost'
  app.set 'port', 3000

app.configure 'production', ->
  app.use express.errorHandler()
  app.set 'domain', 'metal-heart.org'
  app.set 'port', 80

# get some frackin routes
require('./routes') app

app.listen (app.get 'port'), (app.get 'domain')
console.log "Listening to #{app.get 'domain'}:#{app.get 'port'}"

module.exports = app





# app.get '/', (req, res) ->
  
#   tracks.alltracks (results) -> 
#     console.log 'Callback from tracks.alltracks called.'
#     app.locals.results = results



#     res.render 'index',
#       # the 'locals' object is here; these get sent to the template
#       layout: false
#       title: 'Marten\'s Page'
#       results: results

    # res.render 'index',
    #   layout: false,
    #     # hoping this is where 'locals' happens
    #     title: 'Marten\'s Page'
    #     results: results
    
# app.get '/local/:trackId', (req, res) ->

#   # look up track
#   tracks.lookup req.params.trackId, (track) ->
#     #console.log('got track back:')
#     #console.log track
#     #console.log lyric
#     # BAD CODE WARNING
#     # FOR NOW, JUST PUT times IN ONE ARRAY AND lines IN ANOTHER ARRAY
#     lyricData = {}

#     lyricData.timing = (parseInt time for time, line of track.lyrics)
#     lyricData.lyrics = (line for time, line of track.lyrics)

#     console.log typeof lyricData.timimg
#     console.log lyricData.timimg

#     lyricData.youtubeid = track.youtubeid

#     # lyricData.youtubeid = 'WIKqgE4BwAY'
    
#     app.locals.oLyric = lyricData
#     app.locals.youtubeid = track.youtubeid
#     app.locals.artist = track.artist
#     app.locals.title = track.title



#     #app.expose lyricData, 'lyricData'
#     #app.expose('var lyricData = ' + lyricData + ';');

#     res.render 'local',
#       layout: false
#       oLyric: JSON.stringify lyricData
#       youtubeid: track.youtubeid
#       title: track.title

###
This route pulls all the tracks!
TODO add quality filter, in case we want to load good tracks first, and bad
tracks later.
###
# app.get '/data/tracklist/:quality?', (req, res) ->

#   db.get_all_tracks (rows) ->
#     res.json rows

###
This pulls all the track info we need!
Just copied this from /local/:trackId route
TODO def. wanna split db and file ops up into two different calls
###
# app.get '/data/track/:trackId', (req, res) ->

#   # look up track
#   tracks.lookup req.params.trackId, (track) ->
#     #console.log('got track back:')
#     #console.log track
#     #console.log lyric
#     # BAD CODE WARNING
#     # FOR NOW, JUST PUT times IN ONE ARRAY AND lines IN ANOTHER ARRAY
#     lyricData = {}

#     lyricData.timing = (parseInt time for time, line of track.lyrics)
#     lyricData.lyrics = (line for time, line of track.lyrics)

#     console.log typeof lyricData.timimg
#     console.log lyricData.timimg

#     lyricData.youtubeid = track.youtubeid

#     # lyricData.youtubeid = 'WIKqgE4BwAY'
    
#     #app.expose lyricData, 'lyricData'
#     #app.expose('var lyricData = ' + lyricData + ';');

#     res.json
#       "oLyric": lyricData
#       "youtubeid": track.youtubeid
#       "artist": track.artist
#       "title": track.title


     # 'local',
     #  layout: false
     #  oLyric: JSON.stringify lyricData
     #  youtubeid: track.youtubeid
     #  title: track.title




# app.get '/cast/:trackId', (req, res) ->

# # look up track
#   tracks.lookup req.params.trackId, (track) ->
    
#     lyricData = {}

#     lyricData.timing = (parseInt time for time, line of track.lyrics)
#     lyricData.lyrics = (line for time, line of track.lyrics)

#     console.log typeof lyricData.timimg
#     console.log lyricData.timimg

#     lyricData.youtubeid = track.youtubeid

#     # lyricData.youtubeid = 'WIKqgE4BwAY'
    
#     app.locals.oLyric = lyricData
#     app.locals.youtubeid = track.youtubeid
#     app.locals.artist = track.artist
#     app.locals.title = track.title


#     res.render 'sender',
#       layout: false
#       oLyric: JSON.stringify lyricData
#       youtubeid: track.youtubeid
#       title: track.title

# app.get '/receiver', (req, res) ->
#   res.render 'receiver',
#     layout: false



