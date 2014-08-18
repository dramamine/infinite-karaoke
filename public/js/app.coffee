'use strict';

# App Module

karaokeApp = angular.module 'karaokeApp', [
  'ngRoute',
  'ngAnimate',
  'allControllers',
  'allDirectives',
  'mgcrea.ngStrap',
  'ngSanitize', 
  'ngResource',
  'youtube-embed' # https://github.com/brandly/angular-youtube-embed
]
