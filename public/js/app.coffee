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
        templateUrl: 'index.jade',
        controller: 'TrackSearchCtrl'
      }).
      otherwise({
        redirectTo: '/'
      })

    return null
])
