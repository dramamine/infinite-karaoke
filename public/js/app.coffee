'use strict'

# App Module

karaokeApp = angular.module 'karaokeApp', [
  'karaoke.controllers'
  'karaoke.directives'
  'ngRoute'
  'ngAnimate'
  'mgcrea.ngStrap'
  'ngSanitize' 
  'ngResource'
  'youtube-embed' # https://github.com/brandly/angular-youtube-embed
]

angular.module 'karaoke.controllers', []
angular.module 'karaoke.directives', []
