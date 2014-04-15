express = require 'express'
expose = require 'express-expose'
require 'coffee-script'
require 'jade'
tracks = require './tracks'
path = require 'path'

app = express()

#app.configure ->
  #app.use '/public', express.static (__dirname + '/public')
 

# app.use express.static (__dirname + '/public')
# app.use express.static (__dirname + '/views/public')
# app.use express.static '/public', (__dirname + '/views/public')
app.use express.static path.join __dirname, '../public'


app.set 'view engine', 'jade'

app.locals.pretty = true

app.get '/', (req, res) ->
  
  tracks.alltracks (results) -> 
    console.log 'Callback from tracks.alltracks called.'
    app.locals.results = results



    res.render 'index',
      # the 'locals' object is here; these get sent to the template
      layout: false
      title: 'Marten\'s Page'
      results: results

    # res.render 'index',
    #   layout: false,
    #     # hoping this is where 'locals' happens
    #     title: 'Marten\'s Page'
    #     results: results
    
app.get '/local/:trackId', (req, res) ->

  # look up track
  tracks.lookup req.params.trackId, (track) ->
    #console.log('got track back:')
    #console.log track
    #console.log lyric
    # BAD CODE WARNING
    # FOR NOW, JUST PUT times IN ONE ARRAY AND lines IN ANOTHER ARRAY
    lyricData = {}

    lyricData.timing = (parseInt time for time, line of track.lyrics)
    lyricData.lyrics = (line for time, line of track.lyrics)

    console.log typeof lyricData.timimg
    console.log lyricData.timimg

    lyricData.youtubeid = track.youtubeid

    # lyricData.youtubeid = 'WIKqgE4BwAY'
    
    app.locals.oLyric = lyricData
    app.locals.youtubeid = track.youtubeid
    app.locals.artist = track.artist
    app.locals.title = track.title



    #app.expose lyricData, 'lyricData'
    #app.expose('var lyricData = ' + lyricData + ';');

    res.render 'local',
      layout: false
      oLyric: JSON.stringify lyricData
      youtubeid: track.youtubeid
      title: track.title

app.get '/cast/:trackId', (req, res) ->

# look up track
  tracks.lookup req.params.trackId, (track) ->
    
    lyricData = {}

    lyricData.timing = (parseInt time for time, line of track.lyrics)
    lyricData.lyrics = (line for time, line of track.lyrics)

    console.log typeof lyricData.timimg
    console.log lyricData.timimg

    lyricData.youtubeid = track.youtubeid

    # lyricData.youtubeid = 'WIKqgE4BwAY'
    
    app.locals.oLyric = lyricData
    app.locals.youtubeid = track.youtubeid
    app.locals.artist = track.artist
    app.locals.title = track.title


    res.render 'sender',
      layout: false
      oLyric: JSON.stringify lyricData
      youtubeid: track.youtubeid
      title: track.title

app.get '/receiver', (req, res) ->
  res.render 'receiver',
    layout: false


app.use '/app', express.static path.join __dirname, '../app'
app.use express.static path.join __dirname, '../app'

app.listen 3000
console.log 'Listening on port 3000'


