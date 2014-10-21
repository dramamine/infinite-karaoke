http = require("http")
assert = require("assert")
request = require('supertest')
should = require('should')
winston = require('winston')
express = require('express')
app = express()

# app = require("../../src/app")

# request = request('http://localhost:3000')

describe "API", ->
  describe "GET /api/track", ->
    # it "should return all tracks", (done) ->
    #   this.timeout(3000)
    #   http.get
    #     path: "/api/track"
    #     port: 3000
    #   , (res) ->
    #     assert.equal res.statusCode, 200 #, "Expected: 404 Actual: #{res.statusCode}"
    #     done()
    # it "should return a single existing track", (done) ->
    #   http.get
    #     path: "/api/track/5430bd0131e8de5e5d668458"
    #     port: 3000
    #   , (res) ->
    #     assert.equal res.statusCode, 200 #, "Expected: 404 Actual: #{res.statusCode}"
    #     done()
    # it "should not return a nonexistent track", (done) ->
    #   http.get
    #     path: "/api/track/ballz"
    #     port: 3000
    #   , (res) ->
    #     assert.equal res.statusCode, 500 #, "Expected: 404 Actual: #{res.statusCode}"
    #     done()

    it "should return a single existing track using request", (done) ->
      request(app)
        .get("/api/track/5430bd0131e8de5e5d668458")
        .expect(200)
        .end (err, res) ->
          done()

    it "should not return a nonexistent track using request instead of http", (done) ->
      request(app)
        .get("/api/track/ballz")
        .expect(500)
        .end (err, res) ->
          done()



  describe "POST /api/video/comment/", ->
    it "should post a video comment", (done) ->

      postData = 
        rating: -1
        category: 1
        reason: "shitty lyric vid"
        ip: "127.0.0.1"

      request(app)
        .post("/api/video/comment/5430bd0131e8de5e5d6685cd")
        .send(postData)
        .expect(200)
        .end (err, res) ->
          if (err)
            return done(err)
          done()


      # http.post
      #   path: "/api/video/comment/5430bd0131e8de5e5d668458"
      #   port: 3000
      # , (res) ->
      #   assert.equal res.statusCode, 500 #, "Expected: 404 Actual: #{res.statusCode}"
      #   done()