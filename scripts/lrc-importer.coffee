DB_FILE = './data/tracks.json'
LYRIC_FOLDER = './data/lyrics/'

fs = require 'fs'

fs.exists DB_FILE, (exists) -> 
  throw new Error("db file doesn't exist!") unless exists

sqlite3 = require('sqlite3').verbose()
db = new sqlite3.Database DB_FILE

handleEveryFile = ->
  folder_contents = fs.readdirSync LYRIC_FOLDER
  for file in folder_contents

    rex = /(.*?)-.*/
    artist_name_arr = rex.exec file
    artist_name = artist_name_arr[1].trim()

    rex = /.*-(.*?).lrc$/
    track_name_arr = rex.exec file
    track_name = track_name_arr[1].trim()

    console.log artist_name + ":" + track_name

    fs.readFile LYRIC_FOLDER + file, 'utf-8', (err, data) ->
      throw err if err

      # data.split
      # console.log data

      lyric_array = []
      lineProcessor(lyric_array, line) for line in data.toString().split '\n'
        
      # for key, value of lyric_array
      #   console.log key + ":" + value
      #   

    # just run once
    break


# load list of files in lyrics folder
# for each one,
# parse artist and track name
# search DB for that one
# check args to see if user wants to overwrite existing JSON objects
# (and then just exclude from query if user doesn't want them)
# run insert/update stmt

lineProcessor = (lyric_array, line) ->

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
  lyric_array[iMS] = line.substr( line.lastIndexOf("\]") + 1 )
  # console.log 'added k:v ' + iMS + ':' + lyric_array[iMS]
  lineProcessor lyric_array, line.substr( line.indexOf("\]") + 1 )


  return




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
