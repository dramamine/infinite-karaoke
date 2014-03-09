
console.log('loading youtube-lyrics.js');


var videoId = '';
var timing = [ ];
var lyrics = [ ];

// this solution sucks but will have to do for now
var waitingForData = false;

function receiveData(data) {
  console.log("received data!");

  // TODO dynamic
  // this.videoId = data.youtubeid
  this.videoId = data.youtubeid;
  this.timing = data.timing;
  this.lyrics = data.lyrics;

  // start kicking off some things
  // Load the IFrame Player API code asynchronously.
  
  if( this.waitingForData ) this.onYouTubePlayerAPIReady();

}

var tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

// Replace the 'ytplayer' element with an <iframe> and
// YouTube player after the API code downloads.
var player;
function onYouTubePlayerAPIReady() {

  // this solution will have to do for now
  if( videoId === '' )
  {
    this.waitingForData = true;
    return;
  }

  player = new YT.Player('ytplayer', {
    height: '390',
    width: '640',
    videoId: videoId,
    origin: '//localhost:4567', // TODO update this for production
    events: {
    'onReady': onPlayerReady,
    'onStateChange': onPlayerStateChange
    }
  });
  console.log("youtube iframe ready!");
}


// insert timing and lyrics here...
//console.log( {{lyrics}} );
// TODO make this 0
// 

// var timing = [ 20, 3660, 6000 ];
// var lyrics = [ "intro", "zone 4", "get money" ];



var lyricsIndex = 1;
var timer = null;
var offset = 0;

function onPlayerReady(event) {
  console.log("player ready!");
  
  $('.lyricsdiv .times').each(function(item){
    timing.push( parseInt( $(this).text() ) );
    console.log("pushed " + $(this).text());
  });
  $('.lyricsdiv .lines').each(function(item){
    lyrics.push( $(this).text() );
  });

  event.target.playVideo();
      };

function onPlayerStateChange(event) {
  console.log("state changed:" + event.data);

  if (event.data == YT.PlayerState.PLAYING) {

    flashCurrentLyric();

  }
  if (event.data == YT.PlayerState.PAUSED) {
    clearInterval(timer);
  }
};


// just run flash every time the player starts
function flashCurrentLyric() 
{
  var currentTime = player.getCurrentTime() * 1000;
  // look through the array for what lyric should be playing
  var currentLyricFrame = timing.length-1;
  for (var i = 0; i < timing.length; i++) {
    if ( (timing[i] + offset) > currentTime )
    {
      console.log("found time " + timing[i] + " + offset " + offset +  " was greater than current time " + currentTime)
      // previous (or first) frame
      currentLyricFrame = (i > 0)? i-1 : 0;
      break;
    }
  };

  flashLyric(currentLyricFrame, currentTime);

}

// putting this here for now, to keep var in scope
var nextIndex;
function flashLyric(index, currentTime)
{
  if (currentTime == null) currentTime = player.getCurrentTime() * 1000;
  // update page
  $('#lyricsbox').text( lyrics[index] );

  // queue next lyric, if it's not the final frame
  if( index != timing.length - 1 )
  {
    var nextQueueTime = timing[ index + 1 ] + offset;
    var delay = nextQueueTime - currentTime;
    nextIndex = index + 1;
    timer = setTimeout( 
      function(){
        flashLyric(nextIndex);
      },
    delay);
  }

}

function updateOffset()
{
  // TODO might want to restrict this box to integers only
  offset = parseInt( $('#offset').val() );
  flashCurrentLyric();
}


$(document).ready(function(){
  console.log("doc ready!");


});
