
DB_FILE = './data/marten.db'
fs = require 'fs'

fs.exists DB_FILE, (exists) -> 
  throw new Error("db file doesn't exist!") unless exists

sqlite3 = require('sqlite3').verbose()
db = new sqlite3.Database DB_FILE

get_all_tracks = (callback) =>
  # TODO someday, we will cache this stuff.
  # TODO someday, we will move ranking operations out of db queries.
  stmt = "
    SELECT track_id, artist_name, track_name, genre, 
    lyric_id,
    ( SELECT IFNULL( SUM(upvote), 0 )
      FROM lyric_comment
      WHERE lyric.lyric_id = lyric_comment.lyric_id
    ) AS lyric_upvotes,
    video_id,
    ( SELECT IFNULL( SUM(upvote), 0 )
      FROM video_comment
      WHERE video.video_id = video_comment.video_id
    ) AS video_upvotes
    FROM track
    LEFT JOIN lyric USING(track_id)
    LEFT JOIN video USING(track_id)
    "

  results = db.all stmt, (err, rows) ->

    # process quality
    for row in rows

      if !row.lyric_id
        row.lyric_quality = 0
      else if row.lyric_upvotes == 0
        row.lyric_quality = 1
      else if row.lyric_upvotes > 0
        row.lyric_quality = 2
      
      if !row.video_id
        row.video_quality = 0
      else if row.video_upvotes == 0
        row.video_quality = 1
      else if row.video_upvotes > 0
        row.video_quality = 2
      
      row.total_quality = Math.max( row.lyric_quality, row.video_quality )

    callback rows
  
exports.get_all_tracks = get_all_tracks