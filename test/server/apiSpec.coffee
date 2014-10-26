http = require("http")
assert = require("assert")
request = require('supertest')
should = require('should')
express = require('express')

app = require("../../src/app")

# request = request('http://localhost:3000')

describe "API", ->


  describe "GET /track", ->
    # it "should return all tracks", (done) ->
    #   this.timeout(3000)
    #   http.get
    #     path: "/track"
    #     port: 3000
    #   , (res) ->
    #     assert.equal res.statusCode, 200 #, "Expected: 404 Actual: #{res.statusCode}"
    #     done()
    # it "should return a single existing track", (done) ->
    #   http.get
    #     path: "/track/5430bd0131e8de5e5d668458"
    #     port: 3000
    #   , (res) ->
    #     assert.equal res.statusCode, 200 #, "Expected: 404 Actual: #{res.statusCode}"
    #     done()
    # it "should not return a nonexistent track", (done) ->
    #   http.get
    #     path: "/track/ballz"
    #     port: 3000
    #   , (res) ->
    #     assert.equal res.statusCode, 500 #, "Expected: 404 Actual: #{res.statusCode}"
    #     done()

    it "should return all tracks", (done) ->
      request(app)
        .get("/track")
        .expect(200)
        .end (err, res) ->
          if(err)
            done(err)
          else
            done()

    it "should return a single existing track using request", (done) ->
      request(app)
        .get("/track/544c40750ebddbd3157698a3")
        .expect(200)
        .end (err, res) ->
          if(err)
            done(err)
          else
            done()

    it "should not return a nonexistent track", (done) ->
      request(app)
        .get("/track/5430bd0131e8de5e5d668458")
        .expect(404)
        .end (err, res) ->
          if(err)
            done(err)
          else
            done()

    it "should fail on a non-ID-looking ID", (done) ->
      request(app)
        .get("/track/ballz")
        .expect(500)
        .end (err, res) ->
          if(err)
            done(err)
          else
            done()



  # describe "POST /track/", ->
  #   it "should update a track", (done) ->

  #     postData =
  #       quality:
  #         video: 1

  #     request(app)
  #       .post("/track/5430bd0131e8de5e5d668458")
  #       .set('Content-Type', 'application/json')
  #       # .send(postData)
  #       .send({"quality":"1"})
  #       .expect(200)
  #       .end (err, res) ->
  #           if(err)
  #             done(err)
  #           else
  #             done()

  describe "GET /video", ->
    it "should return a single existing best vid", (done) ->
      request(app)
        .get("/video/544c40750ebddbd3157698a3")
        .expect(200)
        .end (err, res) ->
          if(err)
            done(err)
          else
            assert res.body.youtube_id == "LUVY2ehJ0qc"
            assert res.body.best == true
            done()

  describe "GET /videos/", ->
    it "should return multiple videos", (done) ->
      request(app)
        .get("/videos/544c40750ebddbd3157698a3")
        .expect(200)
        .end (err, res) ->
          if(err)
            done(err)
          else
            assert res.body.length > 1
            done()

  # describe "POST /video/comment/", ->
  #   it "should post a video comment", (done) ->

  #     postData =
  #       comment:
  #         rating: -1
  #         category: 1
  #         reason: "shitty lyric vid"
  #         ip: "127.0.0.1"

  #     request(app)
  #       .post("/video/comment/5430bd0131e8de5e5d6685cd")
  #       .send(postData)
  #       .expect(200)
  #       .end (err, res) ->
  #         if (err)
  #           return done(err)
  #         done()


      # http.post
      #   path: "/video/comment/5430bd0131e8de5e5d668458"
      #   port: 3000
      # , (res) ->
      #   assert.equal res.statusCode, 500 #, "Expected: 404 Actual: #{res.statusCode}"
      #   done()