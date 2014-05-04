#
# This file imports everything in the `lyrics` folder into the sqlite
# database. it does this by looking up tracks by artist/track name,
# then inserting/updating the best lyrics record it finds.
# 
# This seems "not great" for the long term, but I'm not too worried
# about it at the moment! Would like to switch to mongoDB for the 
# experience + performance comparison
#
# Usage:
# cd scripts
# coffee lrc-mongo-importer.coffee 
# --reset: reset all tracks before doing anything
# --update: force update of lyric object even if track exists

LYRIC_FOLDER = '../data/lyrics/'

fs = require 'fs'
db = require '../data/db.coffee'
schemas = require '../data/schemas.coffee'


## params ##
args = process.argv.slice(2)
console.log args

reset = false
reset = true for arg in args when arg is '--reset'

force_update = false
force_update = true for arg in args when arg is '--update'


schemas.Track.find().remove().exec() if reset

# Recursive function to process a line. 
# 
# ex. using the line "[00:30:00][00:31:50] Ooh yeah baby!"
#     inserts {time:30000 line:"Ooh yeah baby!"}
#     and     {time:31500 line:"Ooh yeah baby!"}
#     into the lyrics array.
# 
# @param lyrics {Array} An array of objects. Must match the schema 
# lyric.content. Note that we're passing this around as a reference, otherwise 
# this would break.
# 
# @param line {String} The current line

lineProcessor = (lyrics, line) ->

  return null unless /\[.*\].*/.test(line)
  
  # match first [(dd:dd)*] expression
  # minutes = line.match(/\[(\d+):\]/)
  aMinutes = line.match(/\[(\d+)\:.*\]/)
  aSeconds = line.match(/\[\d+\:(\d+).*\]/)
  aHundredths = line.match(/\[\d+\:\d+\.(\d+)\]/)
  
  iMinutes = if aMinutes then aMinutes[1] else 0
  iSeconds = if aSeconds then aSeconds[1] else 0
  iHundredths = if aHundredths then aHundredths[1] else 0

  iMS = 60000 * iMinutes + 1000 * iSeconds + 10 * iHundredths;
  
  lyrics.push
    time: iMS
    line: line.substr( line.lastIndexOf("\]") + 1 ).trim()

  # recursion
  lineProcessor lyrics, line.substr( line.indexOf("\]") + 1 )

handleFile = (file) ->
  
  rex = /(.*?)-.*/
  artist_name_arr = rex.exec file
  artist_name = artist_name_arr[1].trim()

  rex = /.*-(.*?).lrc$/
  track_name_arr = rex.exec file
  track_name = track_name_arr[1].trim()

  data = fs.readFileSync LYRIC_FOLDER + file, 'utf-8'

  lyrics = []
  lineProcessor(lyrics, line) for line in data.toString().split '\n'

  lyric = 
    content: lyrics
    imported: true
    
  #json = escape(JSON.stringify lyrics)
  #console.log json

  schemas.Track.findOne {"artist": artist_name, "track": track_name}, (err, one) ->
    console.error err if err
    if one 
      if force_update
        # already exists, update
        one.lyric = lyric

        one.save (err, track) ->
          console.error err if err
          console.log "updated lyric content of #{artist_name} - #{track_name}" unless err
      else
        console.log "track already exists for #{artist_name} - #{track_name}" unless err

    else
      # insert a new track
      track = new schemas.Track
        artist: artist_name
        track: track_name

      track.lyric = lyric

      track.save (err, track) ->
        console.error err if err
        console.log "created track with lyrics for #{artist_name} - #{track_name}" unless err


  return null

# handles every file in the lyric folder.
# 
handleEveryFile = ->
  folder_contents = fs.readdirSync LYRIC_FOLDER
  for file in folder_contents

    handleFile file

  return null

handleEveryFile()
