express = require 'express'
#expose = require 'express-expose'
require 'coffee-script'
require 'jade'
path = require 'path'
harp = require 'harp'
# these get app.locals working some magic, I guess
util = require 'util'
tp = require 'tea-properties'
df = require 'dateformat'

app = express()

app.configure 'development', ->
  app.use express.errorHandler {dumpExceptions: true, showStack: true}
  app.locals.pretty = true
  app.set 'domain', 'localhost'
  app.set 'port', 3000
  app.set 'database', 'devel'

app.configure 'test', ->
  app.use express.errorHandler {dumpExceptions: true, showStack: true}
  app.locals.pretty = true
  app.set 'domain', 'localhost'
  app.set 'port', 3000
  app.set 'database', 'test'

app.configure 'production', ->
  app.use express.errorHandler()
  app.set 'domain', 'metal-heart.org'
  app.set 'port', 80
  app.set 'database', 'prod'


app.configure ->
  app.set 'views', __dirname + '/views'
  app.locals.basedir = app.get 'views'
  app.set 'view engine', 'jade'
  app.locals.pretty = true

  # connect to our db
  mongoose = require('./db/db').init(app.get('database'))

  # put everything you 'use' in here!
  middleware = [
    express.bodyParser()
  ]
  app.use m for m in middleware

  app.use '/', express.static path.resolve __dirname, '../public'
  app.use '/', harp.mount path.resolve __dirname, '../public'
  # eh, probably not the best place but it'll do for now!
  app.use '/receiver', express.static path.resolve __dirname, '../chromecast-receiver/dist'
  app.use 'favicon', path.resolve __dirname, '../public/favicon.ico'

  app.locals
    get: (obj, loc, def = undefined) -> tp.get(obj, loc) ? def
    inspect: util.inspect
    df: df



# app.listen 666
# console.log 'Listening on port 666'



# get some frackin routes
require('./routes') app

app.listen (app.get 'port'), (app.get 'domain')
console.log "Listening to #{app.get 'domain'}:#{app.get 'port'}"

module.exports = app


