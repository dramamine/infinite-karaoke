
CREATE TABLE track (
track_id INTEGER PRIMARY KEY,
artist_name TEXT,
track_name TEXT,
genre TEXT,
formatted_name TEXT,
created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TRIGGER track_audit 
AFTER UPDATE ON track 
BEGIN 
  UPDATE track SET updated = datetime('now'), 
   formatted_name = genre 
    || " " || artist_name 
    || " " || track_name 
    WHERE track_id = new.track_id;
END;

-- just use this for now
CREATE TRIGGER track_formatted_name
AFTER UPDATE ON track 
BEGIN 
  UPDATE track SET formatted_name = CONC WHERE track_id = new.track_id; 
END;

CREATE TABLE genre (
track_id INTEGER,
genre VARCHAR(12)
)

CREATE TRIGGER genre_update
AFTER UPDATE ON genre 
BEGIN 
  UPDATE track 
  SET genre = (SELECT '#' || group_concat(genre, " #" ) 
               FROM genre
               WHERE new.track_id = genre.track_id
  WHERE track_id = new.track_id


END;

CREATE TABLE lyric (
lyric_id INTEGER PRIMARY KEY,
track_id INTEGER NOT NULL REFERENCES track(track_id),
file TEXT,
json TEXT,
source TEXT,
headline TEXT,
quality INTEGER NOT NULL DEFAULT 0,
created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TRIGGER lyric_audit 
AFTER UPDATE ON lyric 
BEGIN 
  UPDATE lyric SET updated = datetime('now') WHERE lyric_id = new.lyric_id; 
END;

CREATE TABLE lyric_comment (
lyric_comment_id INTEGER PRIMARY KEY,
lyric_id INTEGER REFERENCES lyric(lyric_id),
upvote BOOLEAN DEFAULT 0 NOT NULL,
comment_type INTEGER DEFAULT 0 NOT NULL REFERENCES xref_lyric_comment_type(comment_type),
comment_text TEXT,
comment_text_approved BOOLEAN DEFAULT 0 NOT NULL,
created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
created_by TEXT,
updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TRIGGER lyric_comment_audit 
AFTER UPDATE ON lyric_comment
BEGIN 
  UPDATE lyric_comment SET updated = datetime('now') WHERE lyric_comment_id = new.lyric_comment_id; 
END;


-- TODO this might be nice
-- CREATE UNIQUE INDEX lyric_comment_by_author_idx ON lyric_comment(lyric_id, created_by);


-- HOW TO UPSERT
-- make sure it exists
-- INSERT OR IGNORE INTO players (user_name, age) VALUES ("steven", 32); 

-- make sure it has the right data
-- UPDATE players SET user_name="steven", age=32 WHERE user_name="steven"; 

CREATE TABLE xref_lyric_comment_type (
comment_type INTEGER PRIMARY KEY,
comment_type_desc TEXT NOT NULL
);

INSERT INTO xref_lyric_comment_type VALUES (0, "no comment");
INSERT INTO xref_lyric_comment_type VALUES (1, "lyrics don't sync properly");
INSERT INTO xref_lyric_comment_type VALUES (2, "wrong lyrics for this song");
INSERT INTO xref_lyric_comment_type VALUES (3, "poorly transcribed lyrics");

CREATE TABLE video (
video_id INTEGER PRIMARY KEY,
track_id INTEGER NOT NULL REFERENCES track(track_id),
youtube_id TEXT NOT NULL,
created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TRIGGER video_audit 
AFTER UPDATE ON video
BEGIN 
  UPDATE video SET updated = datetime('now') WHERE video_id = new.video_id; 
END;


CREATE TABLE video_comment (
video_comment_id INTEGER PRIMARY KEY,
video_id INTEGER REFERENCES video(video_id),
upvote BOOLEAN DEFAULT 0 NOT NULL,
comment_type INTEGER DEFAULT 0 NOT NULL REFERENCES xref_video_comment_type(comment_type),
comment_text TEXT,
comment_text_approved BOOLEAN DEFAULT 0 NOT NULL,
created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
created_by TEXT,
updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TRIGGER video_comment_audit 
AFTER UPDATE ON video_comment
BEGIN 
  UPDATE video_comment SET updated = datetime('now') WHERE video_comment_id = new.video_comment_id; 
END;

CREATE TABLE xref_video_comment_type (
comment_type INTEGER PRIMARY KEY,
comment_type_desc TEXT NOT NULL
);

INSERT INTO xref_video_comment_type VALUES (0, "no comment");
INSERT INTO xref_video_comment_type VALUES (1, "official video");
INSERT INTO xref_video_comment_type VALUES (2, "best video");
INSERT INTO xref_video_comment_type VALUES (3, "video has interruptions / non-music parts");
INSERT INTO xref_video_comment_type VALUES (4, "wrong video");

-- test data
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (1, "Arcade Fire", "Ready to Start", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (2, "Black Kids", "I'm Not Gonna Teach Your Boyfriend How To Dance With You", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (3, "Bon Iver", "Skinny Love", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (4, "Chromeo", "Fancy Footwork", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (5, "Chvrches", "Recover", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (6, "Deftones", "Change (In the House of Flies)", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (7, "Foster The People", "Pumped Up Kicks", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (8, "Janelle Monae", "Tightrope (featuring Big Boi)", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (9, "Jimmy Eat World", "Bleed American", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (10, "Nine Inch Nails", " We're In This Together", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (11, "Nine Inch Nails", "Head Like A Hole", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (12, "Owl City", "Deer in the Headlights", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (13, "Radiohead", "Karma Police", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (14, "Rage Against the Machine", "Killing In The Name", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (15, "Refused", "New Noise", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (16, "Rich Boy", "Throw Some D's", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (17, "Taking Back Sunday", "Great Romances Of The 20th Century", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (18, "The Faint", "Desperate Guys", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (19, "The National", "Bloodbuzz Ohio", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (20, "The Postal Service", "Such Great Heights", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (21, "The Weeknd", "Thursday", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (22, "The XX", "VCR", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (23, "Thursday", "Signals Over the Air", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (24, "TV on the Radio", "I Was A Lover", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (25, "TV On The Radio", "Will Do", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (26, "Vampire Weekend", "Giving Up The Gun", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (27, "Wavves", "King of the Beach", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (28, "Yeasayer", "Ambling Alp", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (29, "Miley Cyrus", "Party in the USA", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (30, "The Joy Formidable", "Whirring", "Hipster");
INSERT INTO track (track_id, artist_name, track_name, genre) VALUES (31, "Nicki Minaj", "Beez in the Trap", "Hipster");

INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1001, 1, "Arcade Fire -Ready to Start.lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1002, 2, "Black Kids - I'm Not Gonna Teach Your Boyfriend How To Dance With You.lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1003, 3, "Bon Iver -Skinny Love.lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1004, 4, "Chromeo -Fancy Footwork.lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1005, 5, "Chvrches - Recover.lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1006, 6, "Deftones -Change (In the House of Flies).lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1007, 7, "Foster The People -Pumped Up Kicks.lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1008, 8, "Janelle Monae -Tightrope (featuring Big Boi).lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1009, 9, "Jimmy Eat World -Bleed American.lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1010, 10, "Nine Inch Nails - We're In This Together.lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1011, 11, "Nine Inch Nails -Head Like A Hole.lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1012, 12, "Owl City -Deer in the Headlights.lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1013, 13, "Radiohead -Karma Police.lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1014, 14, "Rage Against the Machine -Killing In The Name.lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1015, 15, "Refused -New Noise.lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1016, 16, "Rich Boy -Throw Some D's (Feat. Polow Da Don) (Produced By Butta, Co-produced By Polow Da Don).lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1017, 17, "Taking Back Sunday -Great Romances Of The 20th Century.lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1018, 18, "The Faint -Desperate Guys.lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1019, 19, "The National -Bloodbuzz Ohio.lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1020, 20, "The Postal Service -Such Great Heights.lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1021, 21, "The Weeknd -Thursday.lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1022, 22, "The XX -VCR.lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1023, 23, "Thursday -Signals Over the Air.lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1024, 24, "TV on the Radio -I Was A Lover.lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1025, 25, "TV On The Radio -Will Do.lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1026, 26, "Vampire Weekend -Giving Up The Gun.lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1027, 27, "Wavves -King of the Beach.lrc", "archive", "I personally tested this.");
INSERT INTO lyric (lyric_id, track_id, file, source, headline) VALUES (1028, 28, "Yeasayer -Ambling Alp.lrc", "archive", "I personally tested this.");

-- 3 upvotes for this guy
INSERT INTO lyric_comment (lyric_id, upvote, comment_type) VALUES (1006, 1, 0);
INSERT INTO lyric_comment (lyric_id, upvote, comment_type) VALUES (1006, 1, 0);
INSERT INTO lyric_comment (lyric_id, upvote, comment_type) VALUES (1006, 1, 0);

-- 2 up, 1 down
INSERT INTO lyric_comment (lyric_id, upvote, comment_type) VALUES (1007, 1, 0);
INSERT INTO lyric_comment (lyric_id, upvote, comment_type) VALUES (1007, 1, 0);
INSERT INTO lyric_comment (lyric_id, upvote, comment_type, comment_text) VALUES (1007, 0, 1, "needs work");

-- 3 down
INSERT INTO lyric_comment (lyric_id, upvote, comment_type) VALUES (1008, 0, 1);
INSERT INTO lyric_comment (lyric_id, upvote, comment_type, comment_text) VALUES (1008, 0, 3, "lern 2 spel");
INSERT INTO lyric_comment (lyric_id, upvote, comment_type, comment_text) VALUES (1008, 0, 1, "needs work");




INSERT INTO video (video_id, track_id, youtube_id) VALUES (2001, 1, "9oI27uSzxNQ");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2002, 2, "rOV6I4fYnvQ");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2003, 3, "ssdgFoHLwnk");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2004, 4, "3ZKq2ptu7qw");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2005, 5, "JyqemIbjcfg");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2006, 6, "WPpDyIJdasg");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2007, 7, "");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2008, 8, "pwnefUaKCbc");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2009, 9, "Ag8yc8yx2LU");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2010, 10, "");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2011, 11, "ao-Sahfy7Hg");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2012, 12, "gtsX8H7xSek");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2013, 13, "IBH97ma9YiI");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2014, 14, "bWXazVhlyxQ");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2015, 15, "NkAe30aEG5c");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2016, 16, "pudIZbCRq_c");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2017, 17, "7xmADtEco3w");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2018, 18, "wG1SUnI7QgU");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2019, 19, "yfySK7CLEEg");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2020, 20, "0wrsZog8qXg");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2021, 21, "0Suprl56Owg");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2022, 22, "gI2eO_mNM88");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2023, 23, "pejvzJZSLpw");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2024, 24, "1J2nlal-ckQ");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2025, 25, "dXLpXu9T7j0");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2026, 26, "bccKotFwzoY");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2027, 27, "uDKh61eMMuE");
INSERT INTO video (video_id, track_id, youtube_id) VALUES (2028, 28, "fvUaK_MWkDg");

-- 3 plain upvotes
INSERT INTO video_comment (video_id, upvote, comment_type )  VALUES(2006, 1, 0);
INSERT INTO video_comment (video_id, upvote, comment_type )  VALUES(2006, 1, 0);
INSERT INTO video_comment (video_id, upvote, comment_type )  VALUES(2006, 1, 0);

-- 2 up, 1 down
INSERT INTO video_comment (video_id, upvote, comment_type )  VALUES(2007, 1, 0);
INSERT INTO video_comment (video_id, upvote, comment_type )  VALUES(2007, 1, 0);
INSERT INTO video_comment (video_id, upvote, comment_type )  VALUES(2007, 0, 3);

-- this vid sux
INSERT INTO video_comment (video_id, upvote, comment_type, comment_text )  VALUES(2010, 0, 3, "wtf is this");
INSERT INTO video_comment (video_id, upvote, comment_type, comment_text )  VALUES(2010, 0, 3, "john mayer??");
INSERT INTO video_comment (video_id, upvote, comment_type )  VALUES(2010, 0, 2);

