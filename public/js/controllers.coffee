'use strict'

# Controllers

allControllers = angular.module('allControllers', ['allServices'])

allControllers.controller 'TrackSearchCtrl', ['$scope', '$resource', 'TrackService', 
  ($scope, $resource, TrackService) -> 
    $scope.myData = {}
    # load placeholder data
    $scope.tracks = TrackService.data
    $scope.myData.tracks = TrackService.data
    # $scope.selectedTrack = 'Test - Test'
    # $scope.myData.selectedTrack = 'Test - Test'

    # not a router, I swear.
    # This is kinda dirty, since "selectedTrack" is either a JSON object with
    # track data, or just the text that the user entered.
    $scope.pickUrl = ->
      if $scope.selectedTrack.value
        # LOL HAX
        # JUST LOAD THE OLD VERSION OF THE PAGE
        # it uses jQuery and all this shit
        # I could write a new directive...some day.
        # 
        # return '#/track/' + $scope.selectedTrack.value
        return '/karaoke/' + $scope.selectedTrack.value
      return '#/search/' + $scope.selectedTrack

      
    # get tracks from the database
    # @see routes/api.coffee
    url = "/api/track"
    resource = $resource(url)
    resource.query {}, (result) ->

      # convert to menu-items
      # TODO probs shouldn't do this in the controller, but whatever.
      angular.forEach result, (track) ->
        track.label = "#{track.artist} - #{track.track}"
        track.value = track._id

      $scope.tracks = result

      console.log result

    return null

]

allControllers.controller 'PlayCtrl', ['$scope', '$resource', 
  ($scope, $resource) -> 

    # $scope.code = 'oHg5SJYRHA0'
    $scope.trackData = {}

    # ng-init gets loaded after the page
    $scope.$watch 'trackid', (newId) ->

      # console.log "querying this ID:" + newId
      url = "/api/track"
      resource = $resource(url)
      resource.query { _id: newId }, (result) ->
        console.log 'updating scope with new data.'
        $scope.trackData = result
        # TODO this is pretty shitty for now, but can fix this up when we add
        # better support for choosing a video.
        $scope.code = result[0].videos[0].youtube_id

    return null

]