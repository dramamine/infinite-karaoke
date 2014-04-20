'use strict';

# App Module

karaokeApp = angular.module 'karaokeApp', [
  'ngRoute',
  'ngAnimate',
  'allControllers',
  'allDirectives',
  'mgcrea.ngStrap',
  'ngSanitize'
]

karaokeApp.config(['$routeProvider',
  ($routeProvider) -> 
    $routeProvider.
      when('/', {
        templateUrl: 'partials/track-search.html',
        controller: 'TrackSearchCtrl'
      }).
      when('/track/:id', {
        templateUrl: 'partials/play.html',
        controller: 'PlayCtrl'
      }).
      otherwise({
        redirectTo: '/'
      })

    return null
])
