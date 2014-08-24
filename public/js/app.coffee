'use strict'

# App Module

karaokeApp = angular.module 'karaokeApp', [
  'ngRoute'
  'ngAnimate'
  'allDirectives'
  'allServices'
  'mgcrea.ngStrap'
  'ngSanitize' 
  'ngResource'
  'youtube-embed' # https://github.com/brandly/angular-youtube-embed
  'karaoke.controllers'
]

angular.module 'karaoke.controllers', ['allServices']
