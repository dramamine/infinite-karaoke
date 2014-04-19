-- test queries!
PRAGMA foreign_keys = ON;


.print TEST: expecting '28'
SELECT count(*) FROM track; 
.print TEST: expecting 'Hipster'
SELECT DISTINCT genre FROM track; 
.print TEST: expecting 'PRIMARY KEY must be unique'
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (1, "Arcade Fire", "Ready to Start", "Hipster"); 

.print TEST: expecting '28'
SELECT count(*) FROM lyric; 
.print TEST: expecting 'archive'
SELECT DISTINCT source FROM lyric; 

.print TEST: expecting '9'
SELECT count(*) FROM lyric_comment; 
.print TEST: expecting '9'
SELECT count(*) FROM video_comment; 

-- test foreign key stuff
.print TEST: expecting 'foreign key constraint failed'
INSERT INTO lyric(track_id) VALUES (9000); 
.print TEST: expecting 'foreign key constraint failed'
INSERT INTO lyric_comment(lyric_id) VALUES (9000); 
.print TEST: expecting 'foreign key constraint failed'
INSERT INTO lyric_comment(lyric_id, comment_type) VALUES (1001, 999); 

.print TEST: expecting 'youtube_id may not be NULL'
INSERT INTO video(track_id) VALUES (1001); 
.print TEST: expecting 'foreign key constraint failed'
INSERT INTO video(track_id, youtube_id) VALUES (9000, ""); 
.print TEST: expecting 'foreign key constraint failed'
INSERT INTO video_comment(video_id) VALUES (9000); 
.print TEST: expecting 'foreign key constraint failed'
INSERT INTO video_comment(video_id, comment_type) VALUES (2001, 999); 