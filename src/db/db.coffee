# gets a database connection and returns it.
# usage:
# db = require 'db.coffee'


mongoose = require 'mongoose'
module.exports = mongoose
module.exports.init = (database) ->

  config = require './dbconfig'
  c = config[database]
  console.log "loading up the " + database + " db"


  if database == 'test'
    addy = "mongodb://#{c.connection}/#{c.database}"
  else
    addy = "mongodb://#{c.username}:#{c.password}@#{c.connection}/#{c.database}"

  mongoose.connect addy

  db = mongoose.connection
  db.on 'error', console.error.bind(console, 'connection error:')
  db.once 'open', ->
    console.log 'got a connection!'

  return mongoose