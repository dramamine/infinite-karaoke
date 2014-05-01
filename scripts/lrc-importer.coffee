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
# coffee scripts/lrc-importer.coffee 
# 

DB_FILE = './data/marten.db'
LYRIC_FOLDER = './data/lyrics/'

fs = require 'fs'

fs.exists DB_FILE, (exists) -> 
  throw new Error("db file doesn't exist!") unless exists

sqlite3 = require('sqlite3').verbose()
db = new sqlite3.Database DB_FILE

# load list of files in lyrics folder
# for each one,
# parse artist and track name
# search DB for that one
# check args to see if user wants to overwrite existing JSON objects
# (and then just exclude from query if user doesn't want them)
# run insert/update stmt

lineProcessor = (lyric_obj, line) ->

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
  
  # find last bracket location
  #lastEndBracket = line.lastIndexOf("\]")
  #sLine = line.substr( lastEndBracket )
  
  # magic! key = time, value = lyric
  lyric_obj[iMS] = line.substr( line.lastIndexOf("\]") + 1 )
  # console.log 'added k:v ' + iMS + ':' + lyric_obj[iMS]
  lineProcessor lyric_obj, line.substr( line.indexOf("\]") + 1 )


  return



# handles every file in the lyric folder.
# 
handleEveryFile = ->
  folder_contents = fs.readdirSync LYRIC_FOLDER
  for file in folder_contents

    console.log "starting this whole process with " + file

    rex = /(.*?)-.*/
    artist_name_arr = rex.exec file
    artist_name = artist_name_arr[1].trim()

    rex = /.*-(.*?).lrc$/
    track_name_arr = rex.exec file
    track_name = track_name_arr[1].trim()

    console.log artist_name + ":" + track_name

    data = fs.readFileSync LYRIC_FOLDER + file, 'utf-8'

    # data.split
    console.log data
    
    # not repeating this loop correctly by filename!
    # TODO FIX
    # 
    lyric_obj = {}
    lineProcessor(lyric_obj, line) for line in data.toString().split '\n'
      
    for key, value of lyric_obj
      console.log key + ":" + value
      
    json = escape(JSON.stringify lyric_obj)
    #console.log json

    # find the right lyric id
    stmt = "SELECT lyric_id
        FROM lyric
        JOIN track USING(track_id)
        WHERE track.artist_name = \"" + artist_name + "\" AND track.track_name = \"" + track_name + "\" ORDER BY lyric.quality DESC
        LIMIT 1"

    console.log stmt

    self = 
      artist_name: artist_name
      track_name: track_name
      json: json

    lyric_callback = (err, rows) ->
      console.log "this is my callback"
      console.log artist_name
    
    lyric_lookup = db.each stmt, (err, rows) ->
      console.log "results from lyric lookup:" + rows
      console.log rows



      # if we found an existing record, update
      if rows[0]

        thelyric = rows[0].lyric_id
        console.log "thelyric is " + thelyric

        # update db with this
        stmt = "UPDATE lyric
          SET json = \"" + json + "\"
          WHERE lyric_id = " + thelyric

        console.log stmt

        update_lyric = db.all stmt, (err, rows) ->
          
          console.log "Updated lyric id " + thelyric
      
      # if there's no record, insert
      else
        stmt = "INSERT INTO track (artist_name, track_name) 
          VALUES (\"" + artist_name + "\", \"" + track_name + "\" )"

        console.log stmt

        track_inserted = db.all stmt, (err, rows) ->
          #console.log "Inserted track record."

          stmt = "SELECT MAX(track_id) AS track_id FROM track"
          max_trackid = db.all stmt, (err, rows) ->
            #console.log rows
            #console.log rows[0]

            stmt = "INSERT INTO lyric (track_id, json)
              VALUES(" + rows[0].track_id + ", \"" +
                json + "\")"

            new_lyric = db.all stmt, (err, rows) ->
              #console.log rows[0]



  return null

    # just run once
    # break
handleEveryFile()




# code I may or may not want to use
readLyricsIntoDB = (lyric_id, file, callback ) ->

  # TOOD async this
  track.retrieveLyrics file, (lyrics) ->
    track.process lyrics, (json) ->
        stmt = "UPDATE lyric
          SET json = " + JSON.stringify json +
          "WHERE lyric_id = " + lyric_id;

        results = db.all stmt, (err, rows) ->

          console.log rows

exports.readLyricsIntoDB = readLyricsIntoDB
