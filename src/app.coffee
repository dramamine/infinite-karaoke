express = require 'express'
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
  res.render 'local',
    layout: false

app.get '/cast/:trackId', (req, res) ->
  res.render 'sender',
    layout: false

app.get '/receiver', (req, res) ->
  res.render 'receiver',
    layout: false


app.listen 3000
console.log 'Listening on port 3000'


