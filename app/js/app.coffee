'use strict'

# App Module

karaokeApp = angular.module 'karaokeApp', [
  'karaoke.controllers'
  'karaoke.directives'
  'ngRoute'
  'ngAnimate'
  'ngSanitize' 
  'ngResource'
  'youtube-embed' # https://github.com/brandly/angular-youtube-embed
  'config'
]

angular.module 'karaoke.controllers', ['ui.bootstrap']
angular.module 'karaoke.directives', []
