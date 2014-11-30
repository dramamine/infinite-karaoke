http = require('http')
assert = require('assert')
request = require('supertest')
should = require('should')
express = require('express')

app = require('../../src/app')

describe 'API', ->

  describe 'GET /search', (done) ->
    it 'should run a search', (done) ->
      request(app)
        .get('/search/TLC')
        .expect(200)
        .end


  describe 'GET /track', ->

    it 'should return all tracks', (done) ->
      request(app)
        .get('/track')
        .expect(200)
        .end (err, res) ->
          if(err)
            done(err)
          else
            done()

    it 'should return a single existing track using request', (done) ->
      request(app)
        .get('/track/547782a8ad1c9c711908ab32')
        .expect(200)
        .end (err, res) ->
          if(err)
            done(err)
          else
            done()

    it 'should not return a nonexistent track', (done) ->
      request(app)
        .get('/track/5430bd0131e8de5e5d668458')
        .expect(404)
        .end (err, res) ->
          if(err)
            done(err)
          else
            done()

    it 'should fail on a non-ID-looking ID', (done) ->
      request(app)
        .get('/track/ballz')
        .expect(500)
        .end (err, res) ->
          if(err)
            done(err)
          else
            done()



  # describe 'POST /track/', ->
  #   it 'should update a track', (done) ->

  #     postData =
  #       quality:
  #         video: 1

  #     request(app)
  #       .post('/track/5430bd0131e8de5e5d668458')
  #       .set('Content-Type', 'application/json')
  #       # .send(postData)
  #       .send({'quality':'1'})
  #       .expect(200)
  #       .end (err, res) ->
  #           if(err)
  #             done(err)
  #           else
  #             done()


  describe 'GET /lyric', ->
    it 'should return a lyric object for an existing track', (done) ->
      request(app)
        .get('/lyric/547782a8ad1c9c711908ab32')
        .expect(200)
        .end (err, res) ->
          if(err)
            done(err)
          else
            done()

    it 'should not return a lyric object for a  non-existent track', (done) ->
      request(app)
        .get('/lyric/000000000000000000000000')
        .expect(204)
        .end (err, res) ->
          if(err)
            done(err)
          else
            done()

    it 'should return an error for non-IDs', (done) ->
      request(app)
        .get('/lyric/ballz')
        .expect(204)
        .end (err, res) ->
          if(err)
            done(err)
          else
            done()


  describe 'GET /video', ->
    it 'should return a single existing best vid', (done) ->
      request(app)
        .get('/video/547782a8ad1c9c711908ab32')
        .expect(200)
        .end (err, res) ->
          if(err)
            done(err)
          else
            assert res.body.youtube_id == 'LUVY2ehJ0qc'
            assert res.body.best == true
            done()

  describe 'GET /videos/', ->
    it 'should return multiple videos', (done) ->
      request(app)
        .get('/videos/547782a8ad1c9c711908ab32')
        .expect(200)
        .end (err, res) ->
          if(err)
            done(err)
          else
            assert res.body.length > 1
            done()

