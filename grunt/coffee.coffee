# MOAR COFFEE
module.exports =

  compile:
    files:
      'public/js/app.js': [
        'app/components/**/*.coffee'
      ]
  # use this to compile all your coffeescript into a single app.js file
  cast:
    files:
      'dist/app.js': '<%= targets.receiver %>'


