'use strict';

# App Module

karaokeApp = angular.module 'karaokeApp', [
  'ngRoute',
  'ngAnimate',
  'allControllers',
  'allDirectives',
  'mgcrea.ngStrap'
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
