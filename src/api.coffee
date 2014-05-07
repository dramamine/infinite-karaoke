#
# 
# API for my mongodb!
# 
# 
# 


class Api
  constructor: (@app) ->

    @app.get '/api/test', @test

    @app.get '/api/user', @getusers

    @app.get '/api/question', @getquestions
    @app.post '/api/question/:_id', @updatequestion
    @app.post '/api/question', @createquestion
    @app.delete '/api/question/:id', @deletequestion

    @app.get '/api/gender', @getgenders
    @app.post '/api/gender/:_id', @updategender
    @app.post '/api/gender', @creategender
    @app.delete '/api/gender/:id', @deletegender


  test: (req, res, next) ->
    


  updategender: (req, res, next) ->
    {_id} = req.params
    Gender.update {_id}, req.body, (err, success) ->
      return res.send 500, err if err
      res.send 200

  creategender: (req, res, next) ->
    console.log req.body
    Gender.create req.body, (err, doc) ->
      return res.send 500, err if err
      res.json {doc}

  getgenders: (req, res, next) ->
    Gender.find req.query, (err, docs) ->
      return res.send 500, err if err
      res.json docs

