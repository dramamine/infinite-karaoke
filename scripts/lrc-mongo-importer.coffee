#
# This file imports everything in the `lyrics` folder into the sqlite
# database. it does this by looking up tracks by artist/track name,
# then inserting/updating the best lyrics record it finds.
#
# If you get 'Bad Request' errors, make sure your IP is allowed! Go here to
# edit the IP list
# https://console.developers.google.com/project/bloodrocution-666/apiui/credential
# Also make sure you have this module installed globally
# npm install youtube-node -g
#
# Usage:
# cd scripts
# coffee lrc-mongo-importer.coffee
# --reset: reset all tracks before doing anything
# --update: force update of lyric object even if track exists
# --prod: use production instead of devel

LYRIC_FOLDER = '../data/lyrics/'

fs = require 'fs'
q = require 'q'

Track = require '../src/models/track'
Video = require '../src/models/video'
Lyric = require '../src/models/lyric'
_ = require 'underscore'


youtube = require 'youtube-node'

## params ##
args = process.argv.slice(2)

reset = false
reset = true for arg in args when arg is '--reset'

force_update = false
force_update = true for arg in args when arg is '--update'

dbstring = 'devel'
dbstring = 'prod' for arg in args when arg is '--prod'

db = require('../src/db/db').init(dbstring)


Track.find().remove().exec() if reset
Video.find().remove().exec() if reset
Lyric.find().remove().exec() if reset

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

  iMS = 60000 * iMinutes + 1000 * iSeconds + 10 * iHundredths

  lyrics.push
    time: iMS
    line: line.substr( line.lastIndexOf("\]") + 1 ).trim()

  # recursion
  lineProcessor lyrics, line.substr( line.indexOf("\]") + 1 )


handleFile = (file) ->

  track = new Track

  rex = /(.*?)-.*/
  artist_arr = rex.exec file
  track.artist = artist_arr[1].trim()

  rex = /.*-(.*?).lrc$/
  title_arr = rex.exec file
  track.title = title_arr[1].trim()

  # shitty async
  createOrFindTrack(track)
  .then (track) ->
    return getVideos(track)

  .then (track) ->
    # console.log track
    # get lyrics from file
    return getLyrics track, file
  .then (track) ->
    console.log 'done with track ' + track.artist + ' - ' + track.title

  return null

# save the track we created to mongodb. insert or maybe update.
createOrFindTrack = (track) ->
  deferred = q.defer()

  Track.findOne {"artist": track.artist, "title": track.title}, (err, one) ->
    console.error err if err
    if one
      if force_update
        # already exists, update
        one.save (err, track) ->
          console.error err if err
          console.log "updated lyric content of #{track.artist} - #{track.title}" unless err
          deferred.resolve track
      else
        console.log "track already exists for #{track.artist} - #{track.title}" unless err
        deferred.resolve track
    else
      # lying/guessing here.
      track.quality =
        video: 2
        lyric: 2
        popular: false

      track.save (err, track) ->
        console.error err if err
        console.log "created track with lyrics for #{track.artist} - #{track.title}" unless err
        deferred.resolve track

  return deferred.promise

# handles every file in the lyric folder.
#
handleEveryFile = ->
  folder_contents = fs.readdirSync LYRIC_FOLDER
  for file in folder_contents
    # TODO warning, no validation here! just grabbing all the files! oh no
    handleFile file

  return null

# Finds some youtube IDs
#
# https://www.npmjs.org/package/youtube-node
#
# @return the numeric video quality
#
getVideos = (track) ->

  deferred = q.defer()
  # number of search results to ask for
  results = 5

  youtube = require 'youtube-node'
  config = require './youtube-api-cfg'

  youtube.setKey config.api_key

  console.log "searching youtube for " + track.artist + "," + track.title
  # search term, number of results, callback
  youtube.search(track.artist + ' ' + track.title, results, (response) ->

    responses = response.items.length
    if responses == 0
      console.error "Weird response."
      console.error response
      console.error response.items.length
      deferred.fail
      return

    for item in response.items
      console.error item.id.kind + " was a weird response " unless item.id.kind = "youtube#searchResult"

      video = new Video
        track: track._id
        youtube_id: item.id.videoId
        title: item.snippet.title
        description: item.snippet.description
        published: item.snippet.publishedAt
        thumbnail: item.snippet.thumbnails.default.url

      video = rateTitle video

      video.save (err, video) ->
        console.log err if err
        # track.videos.push(video)
        console.log video


    # shitty async, videos aren't actually done saving by now
    deferred.resolve track




  )
  return deferred.promise

# get lyrics from the file
getLyrics = ( track, file ) ->
  deferred = q.defer()

  console.log "lyrics being processed..."
  data = fs.readFileSync LYRIC_FOLDER + file, 'utf-8'

  lyrics = []
  lineProcessor(lyrics, line) for line in data.toString().split '\n'

  lyrics = _.sortBy lyrics, 'time'
  lyrics = _.unique lyrics, false, (item) -> return JSON.stringify(item)

  lyric = new Lyric
    track: track._id
    content: lyrics
    imported: true

  lyric.save (err, lyric) ->
    console.log err if err
    deferred.resolve track

  return deferred.promise

# basic function to look at video titles and pre-rate them before users see them
rateTitle = (video) ->
  return video unless video.title
  title = video.title.toLowerCase()
  score = 0
  comments = []

  stringsToCheck =
    'official': 1
    'lyric': -1
    'live': -1

  for check, rating of stringsToCheck
    if title.indexOf(check) > -1
      score += rating
      comments.push
        rating: rating
        category: 0 # TODO magic number, oops
        reason: 'has \'' + check + '\' in name'
        ip: '127.0.0.1'

      # console.log 'found a ' + check + ' music video.'

  video.score = score
  video.comments = comments
  return video


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




# test one file
# handleFile('Owl City -Deer in the Headlights.lrc')

##
# this is the part of the file that executes
##
handleEveryFile()


