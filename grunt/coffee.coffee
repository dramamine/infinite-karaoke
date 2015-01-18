# MOAR COFFEE
module.exports =

  compile:
    files:
      'public/js/app.js': '<%= targets.main %>'
  # use this to compile all your coffeescript into a single app.js file
  cast:
    files:
      'dist/app.js': '<%= targets.receiver %>'


