# gets a database connection and returns it.
# usage: 
# db = require 'db.coffee'

config = require './dbconfig'

c = config.credentials

mongoose = require 'mongoose'
addy = "mongodb://#{c.username}:#{c.password}@#{c.connection}/#{c.database}"
mongoose.connect addy

db = mongoose.connection
db.on 'error', console.error.bind(console, 'connection error:')
db.once 'open', ->
  console.log 'got a connection!'

module.exports = mongoose