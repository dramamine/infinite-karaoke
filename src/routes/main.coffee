##
# Main route for the index page.
class Main
  constructor: (@app) ->

    @app.get '/', @index

  index: (req, res) -> res.render 'index'

module.exports = (app) -> new Main app
