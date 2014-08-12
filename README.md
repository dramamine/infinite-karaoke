# Infinite Karaoke App
![Progress Bar](http://progressed.io/bar/29?title=progress

Karaoke app to sync youtube videos and lyrics. See a live demo at http://metal-heart.org/app/

Written using the MEAN stack (MongoDB, Express, AngularJS, Node)

written in coffeescript and jade because dont you just hate punctuation

# Run with grunt
cd ~/Dropbox/karaoke
grunt

# Then go to
localhost:3000

# First time setup?
Run these:
sudo npm install -g grunt grunt-cli
sudo apt-get install mongodb-clients


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


