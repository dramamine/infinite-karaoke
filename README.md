# HI HI

# Run with grunt
cd ~/Dropbox/lastfm-stats-js
grunt

# Then go to
localhost:3000


# TIME LOG

3/7
3h - messed around with a bunch of seeding apps before I chose one I was trying at work: [http://docs.angularjs.org/tutorial/] one step at a time, I added my own JSON data source and edited the menus.
1h - got youtube part working

3/8
1h - my first directive!
1h15m - get lyrics shittily working
1h - got lyrics less-shittily working (still shitty tho) 

8pm - 10:47pm
https://developers.google.com/cast/docs/custom_receiver

Application ID: 8F0DAF02
using this as my receiver app URL:
https://googledrive.com/host/0B5dY8T0BcJ0ScTRSRjI4V0ltYWs/receiver.html

So I started by trying out the HelloTV app,
but I couldn't get it working (either didn't wait long enough, or used a bad namespace)
Then I grabbed Cast-HelloText and uploaded receiver code to Drive.
Next: run the client locally and try to get it working

3/9
12:30pm
45m - get Sender/Receiver stuff working

device IP: 192.168.1.4
MAC: 6c:ad:f8:4c:e4:a6

try going here: 192.168.1.4:9222

OH SHIT I FUCKING DID IT
- had to factory reset and then check a box for "send device's serial #" to get it to work.
- then had to restart the device after setup

4/19
2h30m - db setup & grunt tasks
4h - add typeahead with icons
2h - make front page prettier, contemplate writing directives.

# DEV CONSOLE
Allows you to inspect elements on the tv screen, check JS console & stuff.
192.168.1.4:9222

30m - move to Express
30m - move index, local to Jade

1h - incorporate sender/receiver
30m - get a youtube vid to show up (!!)

1h - read lyrics from a file
30m - start processing those lyrics




# TODO LIST

(2) this JS code sux, make sure it breaks less
    - related: switch to using [{time: lyric, time: lyric}] JSON format.
(3) switch to using ng-model and a text box or something for the lyrics

(3) look into callbacks and error handling in tracks.coffee#lookup

(4) switch to using MongoDB instead of using flat JSON files
    - update db reads only for now

(4) make db functions to update database
    - CRUD

# LET'S RE-ARCHITECT THIS THING
- Switch to Angular for the front-end stuff, so we can borrow ideas from the thinflash demo (such as accordion menus). Use coffeescript and jade, though.
- Switch to a RESTful API for supplying lyric & youtube data.
- these would hit the database first, then on no results, would hit the youtube / lyric APIs we specify.
-- ex. /verified_tracks
{
  id: 1
  artist
  title
  status [VERIFIED]
}
-- ex. /search/artist/:artist_name/title/:song_title
-- or /video_search/:artist_name/:song_title
-- &  /lyric_search/:artist_name/:song_title
{
  youtube_results: [
    {
      youtube_id, title, thumbnail_url
    }
  ]

  lyric_results: [
    {
      status [VERIFIED, SYNCED, UNSYNCED, NONE]
      rating (upvotes, downvotes)
    }
  ]
}

# DEPLOYING TO DIGITALOCEAN

## install node
https://www.digitalocean.com/community/articles/how-to-install-node-js-with-nvm-node-version-manager-on-a-vps

# install these things
grunt grunt-cli express coffee-script

# maybe install sqlite3 if you wanna reset your db
apt-get install sqlite3

## add this to your ~/.ssh/config
Host ocean
    User root
    HostName 162.243.16.174

## deploy, shitty way!
scp -r ./ ocean:/karaoke

## deploy, awesome way
https://www.digitalocean.com/community/articles/how-to-set-up-automatic-deployment-with-git-with-a-vps

## do this remotely:
## read the guide

## do this locally
git remote add ocean ssh://root@162.243.16.174/var/repo/infinite-karaoke.git
git push ocean master

## need to copy over static-ish files
scp -r ./app/lib ocean:/var/www/metal-heart.org/app/
scp -r ./app/css ocean:/var/www/metal-heart.org/app/
scp -r ./app/img ocean:/var/www/metal-heart.org/app/

# do I even need this
scp -r ./public ocean:/var/www/metal-heart.org/
# careful, you're even uploading the db
scp -r ./data ocean:/var/www/metal-heart.org/
