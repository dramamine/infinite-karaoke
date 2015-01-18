module.exports =
  # https://github.com/gruntjs/grunt-contrib-jade

  # use this to compile Chromecast receiver files into a single index.html
  cast:
    options:
      pretty: true
    files:
      "dist/index.html": "src/views/receiver.jade"
