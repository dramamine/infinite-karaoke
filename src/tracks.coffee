file_location = './data/tracks.json'
fs = require 'fs'


alltracks = (callback) ->
  fs.exists file_location, (exists) -> 
    console.log 'this file exists.' if exists

  fs.readFile file_location, 'utf8', (err, data) ->
    throw err if err
    callback JSON.parse data


exports.alltracks = alltracks
