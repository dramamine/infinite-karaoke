# Infinite Karaoke App
![Progress Bar](http://progressed.io/bar/30?title=progress)

Karaoke app to sync youtube videos and lyrics. See a live demo at http://metal-heart.org/app/

Written using the MEAN stack (MongoDB, Express, AngularJS, Node)

written in coffeescript and jade because dont you just hate punctuation

## What's going on behind-the-scenes?
- Have a collection of .lrc files (timestamps + lyrics) stored locally in `data/lyrics/` for all the songs in the dropdown menu.
- Search using the Youtube API for a music video to go along with these songs.
- Populate everything into mongo.

In future iterations of this, users will have better control over which videos are used, and will be able to search for lyrics and videos for any song. Users will also provide feedback so that each song has a 'canonical' version. Users can also edit lyric timing using sync tools, since lyric files from weird sources are not always perfect.

# Run with grunt
cd ~/Dropbox/karaoke
grunt

# Then go to
localhost:3000

# First time setup?
Run these:
sudo npm install -g grunt grunt-cli
sudo apt-get install mongodb-clients

Create config files in the data/ folder; you need a youtube API key and a mongodb database (get one free at [mongolab](http://mongolab.com)).

Run this to populate your database
coffee scripts/lrc-mongo-importer.coffee

## Rough TODO List, Maybe Up-to-Date

fix up project organization
---------------------
this folder is a mess anyway
copy over flat files
folders for src/ and app/ only 
  app/chromecast
  app/public
  test
kill dead files
switch to HARP to serve up straight coffee / jade

play songs from my personal collection
--------------------------------------
switch tracks.coffee to use mongodb
add lyric editing
add video feedback
add lyric feedback
create lyric-syncing directive
  interact with the youtube javascript object
    window listeners, eh?
  create lyric display component
  handle progress bar


playing any song ever
---------------------
add lyric editor
add youtube search feature

queueing
--------
plan out the interface
  how can a user add to the end of the queue? 
  & the top of the queue?
switch dropdown to send things to the queue


