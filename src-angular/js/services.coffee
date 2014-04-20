'use strict'

# Services

allServices = angular.module('allServices', [])

allServices.service('SampleService', [
  -> 
    this.data = [{
    "artist_name": "Metallica", "track_name": "Lover's Quarrel"
    }, 
    {
      "artist_name": "Altar of Plagues", "track_name": "Lover's Quarrel"
    }, 
    {
      "artist_name": "Death Cab for Cutie", "track_name": "Lover's Quarrel"
    }, 
    {
      "artist_name": "Owl City", "track_name": "Lover's Quarrel"
    }, 
    {
      "artist_name": "Fear Factory", "track_name": "Lover's Quarrel"
    }, 
    {
      "artist_name": "The Postal Service", "track_name": "Lover's Quarrel"
    }, 
    {
      "artist_name": "Band 5", "track_name": "Lover's Quarrel"
    }, 
    {
      "artist_name": "Band 6", "track_name": "Lover's Quarrel"
    }, 
    {
      "artist_name": "Band 7", "track_name": "Lover's Quarrel"
    }, 
    {
      "artist_name": "Band 8", "track_name": "Lover's Quarrel"
    }]

    return null
])

allServices.service('TrackService', ['$http',
  ($http) ->

    this.data = [{
      artist_name: "Placeholder",
      track_name: "Be Patient"
      }]

    this.getData = ->
      
      url = 'http://localhost:3000/data/tracklist'
      promise = $http.get(url)
      .then (results) ->
        # TODO check headers and stuff
        console.log 'Got data back from express.'
        return results.data

      return promise

    return null

])