
DB_FILE = './data/tracks.json'
LYRIC_FOLDER = './data/lyrics/'
fs = require 'fs'

# Returns a JSON object of all track files.
alltracks = (callback) ->
  fs.exists DB_FILE, (exists) -> 
    console.log 'this file exists.' if exists

  fs.readFile DB_FILE, 'utf8', (err, data) ->
    throw err if err
    callback JSON.parse data


exports.alltracks = alltracks

# lol, get a real database n00b
# Returns lyrics for a given track. The lyrics returned are in an array of lines.
lookup = (trackId, callback) ->
  console.log 'lookup called'
  track = {}

  getTrack trackId, (trackJSON) ->
    #console.log 'got data back from getTrack'
    #console.log trackJSON

    track.artist = trackJSON.artist
    track.title = trackJSON.title
    track.youtubeid = trackJSON.youtubeid
    track.offset = trackJSON.offset

    retrieveLyrics trackJSON.lyrics, (lyrics) ->
      process lyrics, (lyricObject) ->
        
        track.lyrics = lyricObject
        callback track

## end lookup
exports.lookup = lookup

# Converts lyric files into a lyric object with timing and lines
process = (lyrics, callback) ->
  
  oLyric = {}

  # good excuse to use recursion!
  # some lrc files have lines like this:
  # [01:45][01:48][01:51][01:54][02:01]Burn, burn, yes ya gonna burn
  # 
  # even though the standard format is this, with repeated lines:
  # [01:59.74]just bought a cadilac
  lineProcessor = (line) ->

    return "NO MATCH" unless /\[.*\].*/.test(line)
    
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
    oLyric[iMS] = line.substr( line.lastIndexOf("\]") + 1 )

    lineProcessor line.substr( line.indexOf("\]") + 1 )
    return
  
  # process all the lines! 
  lines = lyrics.toString().split "\n"
  lineProcessor line for line in lines

  callback oLyric


## PRIVATE METHODS

getTrack = (trackId, callback) ->
  trackId = parseInt trackId
  #console.log 'getTrack called with ' + trackId
  fs.exists DB_FILE, (exists) -> 
    #console.log 'db file exists.' if exists

  fs.readFile DB_FILE, 'utf8', (err, data) ->
    return err if err

    lyricFile = ''
    for track in JSON.parse data
      #console.log "checking " + typeof track.id + " against " + typeof trackId
      if track.id == trackId
        #console.log 'found a matching track id (' + trackId + ') with file ' + track.lyrics
        callback track
        return
    callback "Couldn't find a track with that track ID" 
    return
# end getLyricsFileLocation

retrieveLyrics = (file, callback) ->
  #console.log 'combining up ' + file
  lyricFileLocation = LYRIC_FOLDER + file 

  #console.log 'looking up ' + lyricFileLocation

  fs.exists lyricFileLocation, (exists) -> 
    #console.log 'lyric file exists.' if exists

  # read from the lyric folder
  fs.readFile lyricFileLocation, 'utf8', (err, data) ->
    #console.log err
    return err if err
    #console.log 'found some lyrics!' + data
    callback data
    return
  return
# end retrieveLyrics