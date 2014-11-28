##
# Main route for the index page.
class Main
  constructor: (@app) ->

    @app.get '/', @index

  index: (req, res) ->
    console.log req.query
    res.render 'index', req.query


module.exports = (app) -> new Main app
