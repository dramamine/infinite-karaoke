#
# index.coffee - This may be a bit overkill for now, as I'm only planning to
# use routes for back-end code (and use $routeProvider for the front-end). But
# whatever. Using Adam/Daryl's setup.
module.exports = (app) ->
  routes = [
    #'api'
    'comment'
    'karaoke'
    'lyric'
    'main'
    'track'
    'video'
  ]
  require("./#{r}") app for r in routes
