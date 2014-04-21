DB_FILE = './data/tracks.json'
LYRIC_FOLDER = './data/lyrics/'

fs = require 'fs'

fs.exists DB_FILE, (exists) -> 
  throw new Error("db file doesn't exist!") unless exists

sqlite3 = require('sqlite3').verbose()
db = new sqlite3.Database DB_FILE

folder_contents = fs.readdirSync LYRIC_FOLDER
for file in folder_contents
  whatever

# load list of files in lyrics folder
# for each one,
# parse artist and track name
# search DB for that one
# check args to see if user wants to overwrite existing JSON objects
# (and then just exclude from query if user doesn't want them)
# run insert/update stmt


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
