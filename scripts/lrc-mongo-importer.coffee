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
q = require 'q'
db = require '../data/db.coffee'
schemas = require '../data/schemas.coffee'

youtube = require 'youtube-api'

## params ##
args = process.argv.slice(2)

reset = false
reset = true for arg in args when arg is '--reset'

force_update = false
force_update = true for arg in args when arg is '--update'


schemas.Track.find().remove().exec() if reset
schemas.Video.find().remove().exec() if reset
schemas.Lyric.find().remove().exec() if reset

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
  
  track = new schemas.Track

  rex = /(.*?)-.*/
  artist_arr = rex.exec file
  track.artist = artist_arr[1].trim()

  rex = /.*-(.*?).lrc$/
  title_arr = rex.exec file
  track.title = title_arr[1].trim()

  # shitty async
  getVideos(track)
  .then (track) ->
    console.log track
    # get lyrics from file
    return getLyrics track, file
  .then (track) ->
    # save the track we created to mongodb. insert or maybe update.
    schemas.Track.findOne {"artist": track.artist, "title": track.title}, (err, one) ->
      console.error err if err
      if one 
        if force_update
          # already exists, update
          one.save (err, track) ->
            console.error err if err
            console.log "updated lyric content of #{track.artist} - #{track.title}" unless err
        else
          console.log "track already exists for #{track.artist} - #{track.title}" unless err
      else
        track.save (err, track) ->
          console.error err if err
          console.log "created track with lyrics for #{track.artist} - #{track.title}" unless err
    

  return null

# handles every file in the lyric folder.
# 
handleEveryFile = ->
  folder_contents = fs.readdirSync LYRIC_FOLDER
  for file in folder_contents

    handleFile file

  return null

# Finds a youtube ID
# TODO for now just grab one youtube ID.
# 
# https://www.npmjs.org/package/youtube-node
# 
getVideos = (track) ->

  deferred = q.defer()
  # number of search results to expect
  results = 10
  # result array
  track.videos = []

  youtube = require 'youtube-node'
  config = require '../data/youtube-api-cfg'

  youtube.setKey config.api_key

  console.log "searching youtube for " + track.artist + "," + track.title
  # search term, number of results, callback
  youtube.search(track.artist + ' ' + track.title, results, (response) ->

    console.error "Weird response." unless response.items.length > 0
    
    for item in response.items
      console.error item.id.kind + " was a weird response " unless item.id.kind = "youtube#searchResult"

      video = new schemas.Video
        youtube_id: item.id.videoId
        title: item.snippet.title
        description: item.snippet.description
        published: item.snippet.publishedAt
        thumbnail: item.snippet.thumbnails.default.url
      
      video.save (err, video) ->
        track.videos.push(video)
        # console.log video

        # shitty async??
        deferred.resolve track if track.videos.length == response.items.length


      

  )
  return deferred.promise

# get lyrics from the file
getLyrics = ( track, file ) ->

  console.log "lyrics being processed..."
  data = fs.readFileSync LYRIC_FOLDER + file, 'utf-8'

  lyrics = []
  lineProcessor(lyrics, line) for line in data.toString().split '\n'

  track.lyrics = new schemas.Lyric
    content: lyrics
    imported: true

  console.log "returning them."
  return track



# TEST CODE
# track =
#   thing: "hello world"

# getVideos(track)
# .then (data) ->
#   console.log 'then called.'
#   track.video = data
#   getLyrics track, 'Owl City -Deer in the Headlights.lrc'
#   console.log 'got lyrics'
# .then () ->





# handleFile('Owl City -Deer in the Headlights.lrc')

##
# this is the part of the file that executes
##
handleEveryFile()


