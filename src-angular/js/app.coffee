'use strict';

# App Module

karaokeApp = angular.module 'karaokeApp', [
  'ngRoute',
  'allControllers',
  'allDirectives'
]

karaokeApp.config(['$routeProvider',
  ($routeProvider) -> 
    $routeProvider.
      when('/', {
        templateUrl: 'partials/track-search.html',
        controller: 'TrackSearchCtrl'
      }).
      otherwise({
        redirectTo: '/'
      })

    return null
])
