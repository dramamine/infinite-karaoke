module.exports = (grunt) ->


  require('load-grunt-config') grunt,
    init: true #auto grunt.initConfig
    config:
      # load in the module information
      #pkg: grunt.file.readJSON 'package.json'
      # path to Grunt file for exclusion

      targets:
        src: [
          'app/**/partials/*.html'
          'app/**/*.coffee'
          'app/css/*.css'
          'src/**/*.coffee'
          'src/**/*.jade'
          'test/**/*.coffee'
          'chromecast-receiver/src/**/*.coffee'
          'chromecast-receiver/src/**/*.jade'
        ]
        coffeeonly: [
          'app/js/**/*.coffee'
          'src/**/*.coffee'
          'test/**/*.coffee'
        ]
      gruntfile: ['Gruntfile.coffee']
      bower: '<json:bower.json>'


  grunt.registerTask 'build', [
    # build receiver files
    'build-cast'

    'coffeelint'
    'clean'
    'copy:default'
    'coffee:compile'
    # 'ngconstant:development'
  ]

  grunt.registerTask 'build:fast', [
    'coffeelint'
    'build-cast'
    'copy:default'
  ]

  grunt.registerTask 'build:prod', [
    # build and package receiver files
    # see README for receiver deployment instructions
    'build-cast'
    'shell:package'

    'coffeelint'
    'clean'
    'copy:default'
    # 'ngconstant:production'
  ]

  grunt.registerTask 'develop', [
    'env:dev'
    'build'
    'express:watch'
    'watch'
  ]
  grunt.registerTask 'test-develop', [
    'env:test'
    'shell:testharness'
    'build'
    'express:watch'
    'watch'
  ]

  grunt.registerTask 'deploy', [
    'env:prod'
    'shell:deploy'
  ]

  grunt.registerTask 'test', [
    'env:dev' # not using the test db...yet...
    # 'shell:testharness'
    # 'shell:dbclean'
    'mochaTest'
  ]

  grunt.registerTask 'build-cast', [
    'copy:cast'
    'coffee:cast'
    'jade:cast'
  ]

  grunt.registerTask 'forever-start', [
    'env:prod'
    # 'ngconstant:production'
    'forever:server:start'
  ]

  grunt.registerTask 'forever-stop', [
    'forever:server:stop'
  ]
  grunt.registerTask 'forever-restart', [
    'forever:server:restart'
  ]