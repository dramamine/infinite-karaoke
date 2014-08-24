'use strict'

mod = angular.module('playbackService', [])

# TODO: wire up this service to the controllers
# and to the app itself
mod.service 'PlaybackService', ($rootScope) ->
  trackid = 1
  return {
      set_trackid: (newid) ->
        trackid = newid
        $rootScope.$broadcast('trackUpdate', trackid)
    } 