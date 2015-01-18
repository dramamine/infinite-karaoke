# Infinite Karaoke App
![Progress Bar](http://progressed.io/bar/30?title=progress)

Karaoke app to sync youtube videos and lyrics. See a live demo at http://metal-heart.org

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

## Folder Structure
app/
  Source folder for all Angular components
data/
  Lyric files, misc db stuff
forever/
  Log files from running on production
grunt/
  Grunt tasks
lib/
  Bower components
public/
  Distribution folder for browser app, served as a static folder
scripts/
  Various one-off scripts (data import, etc.)
src/
  Source folder for server code (Node, Express)
static/
  Static components (CSS, images)
test/
  lol.


## Rough TODO List, Maybe Up-to-Date


## TODO LIST
- (8) Chromecast Support
  + you started this on 'chromecast' branch
  + the sender app maybe works, but you need a receiver app
  + host this on mylifeismetal without https, or find https host?
  + this FINALLY ANSWERED MY QUESTION about how to host on google drive
    https://productforums.google.com/forum/#!topic/drive/MyD7dgLJaEo
  + hosting on:
    https://googledrive.com/host/0B5dY8T0BcJ0Sa1M5OHNLSE1hSmM/index.html
  + upload by dragging filez to your folder karaoke-receiver on google drive
  + Chromecast debugger
  + http://192.168.1.4:9222/

- (2) Fix Gruntfile file lists
  + Right now, you have chromecast receiver files in your main app
    and vice versa
    Fix up your 'targets' list and update 'copy' task!
    http://gruntjs.com/configuring-tasks

- (2) Set up config / ngconstant
    + You removed this while reorganizing everything bc it wasn't 
      doing anything
- (1) Move search further up the page
- (3) Add lyric offset adjustment
- (1) Fix 'cannot read property time/line of undefined' from updateLyric
- (2) Make sure bestVid is running
- (2) Try using jade partials instead of html
- (3) Override $log and implement AJAX /log endpoint
- (2) Remove rating from the categories API call; handle this serverside only

+ (2) Add 'video search'; keep it modular so you can re-use it
+ (2) Set the youtube directive to refresh the clock every second
+ (3) Fix CSS, use progress bars
+ (3) Change the URL params to autoload a page
+ (5) Use search result panels instead of typeahead



REORG - THINGS TO DO LATER
- rename module 'karaokeApp'
- create these modules:
  + 'data' (does this really need to be its own module?)
  + 'tweaks'
  + 'search'
  + 'display' (need to check the organization on this; make it fit better with cc-receiver)
  + 'queue' (doesnt exist yet)
  + 'chromecast-sender'
  + 'chromecast-receiver'


# OLDER TODO LIST, Stop Reading

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


