  var firstScriptTag, flashCurrentLyric, flashLyric, lyrics, lyricsIndex, offset, onPlayerReady, onPlayerStateChange, onYouTubePlayerAPIReady, player, receiveData, tag, timer, timing, updateOffset, videoId, waitingForData;

  console.log('loading youtube-lyrics.js');

  tag = document.createElement('script');

  tag.src = "https://www.youtube.com/iframe_api";

  firstScriptTag = document.getElementsByTagName('script')[0];

  firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

  player = null;

  onYouTubePlayerAPIReady = function() {
    if (!videoId) {
      this.waitingForData = true;
      return;
    }
    player = new YT.Player('ytplayer', {
      height: '390',
      width: '640',
      videoId: videoId,
      origin: '//localhost:4567',
      events: {
        'onReady': onPlayerReady,
        'onStateChange': onPlayerStateChange
      }
    });
    return console.log("youtube iframe ready!");
  };

  lyricsIndex = 1;

  timer = null;

  offset = 0;

  onPlayerReady = function(event) {
    console.log("player ready!");
    return event.target.playVideo();
  };

  onPlayerStateChange = function(event) {
    console.log("state changed:" + event.data);
    if (event.data === YT.PlayerState.PLAYING) {
      flashCurrentLyric();
    }
    if (event.data === YT.PlayerState.PAUSED) {
      return clearInterval(timer);
    }
  };

  flashCurrentLyric = function() {
    var currentLyricFrame, currentTime, i;
    currentTime = player.getCurrentTime() * 1000;
    currentLyricFrame = timing.length - 1;
    i = 0;
    while (i < timing.length) {
      if ((timing[i] + offset) > currentTime) {
        currentLyricFrame = i > 0 ? i - 1 : 0;
        break;
      }
      i++;
    }
    return flashLyric(currentLyricFrame, currentTime);
  };

  flashLyric = function(index, currentTime) {
    var delay, nextIndex, nextQueueTime;
    if (!currentTime) {
      currentTime = player.getCurrentTime() * 1000;
    }
    console.log("Sending " + lyrics[index] + " to box.");
    $('#lyricsbox').text(lyrics[index]);
    if (index !== timing.length - 1) {
      nextQueueTime = timing[index + 1] + offset;
      delay = nextQueueTime - currentTime;
      nextIndex = index + 1;
      return timer = setTimeout(function() {
        return flashLyric(nextIndex);
      }, delay);
    }
  };

  updateOffset = function() {
    offset = parseInt($('#offset').val);
    return flashCurrentLyric;
  };

  videoId = '';

  timing = lyrics = [];

  waitingForData = false;

  receiveData = function(data) {
    console.log("received data!");
    this.videoId = data.youtubeid;
    this.timing = data.timing;
    this.lyrics = data.lyrics;
    if (this.waitingForData) {
      return this.onYouTubePlayerAPIReady();
    }
  };

  $(document).ready(function() {
    return console.log("doc ready!");
  });
