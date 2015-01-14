'use strict'

# App Module

karaokeApp = angular.module 'karaokeReceiverApp', [
  'karaoke.controllers'
  'karaoke.directives'
  'karaoke.services'
  'karaoke.receiver'
  'ngRoute'
  'ngAnimate'
  'ngSanitize'
  'ngResource'
  'youtube-embed' # https://github.com/brandly/angular-youtube-embed
  'config'
  'angular-underscore'
]

angular.module 'karaoke.controllers', ['ui.bootstrap', 'karaoke.services']
angular.module 'karaoke.directives', []
angular.module 'karaoke.services', []