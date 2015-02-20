module.exports = (grunt) ->


  require('load-grunt-config') grunt,
    init: true #auto grunt.initConfig
    config:
      # load in the module information
      #pkg: grunt.file.readJSON 'package.json'
      # path to Grunt file for exclusion

      targets:
        src: [
          'app/**/*.coffee'
          'src/**/*.coffee'
          'src/**/*.jade'
          # 'test/**/*.coffee'
          # 'chromecast-receiver/src/**/*.coffee'
          # 'chromecast-receiver/src/**/*.jade'
        ]
        templates: [
          'src/**/*.jade'
        ]
        styles: [
          'app/views/stylesheets/*.sass'
        ]
        # be sure to exclude any receiver-only components
        main: [
          'app/**/*.coffee'
          '!app/cromecast.receiver/*'
        ]
        # make sure this is in sync with _chromecast.receiver.coffee
        receiver: [
          'app/_config.coffee'
          'app/chromecast.receiver/**/*.coffee'
          'app/data/**/*.coffee'
          'app/display/**/*.coffee'
        ]
        coffeeonly: [
          'app/**/*.coffee'
          'src/**/*.coffee'
          'test/**/*.coffee'
        ]
      gruntfile: ['Gruntfile.coffee']
      bower: '<json:bower.json>'


  grunt.registerTask 'build', [
    'sass:dist'
    'coffeelint'
    'clean:default'
    'copy:default'
    'coffee:compile'
  ]

  grunt.registerTask 'build:dev', [
    'sass:dev'
    'coffeelint'
    'clean:default'
    'copy:default'
    'coffee:compile'
  ]

  grunt.registerTask 'build:cast', [
    'clean:cast'
    'copy:cast'
    'coffee:cast'
    'jade:cast'
    'shell:deploycast'
  ]

  grunt.registerTask 'develop', [
    'env:dev'
    'build:dev'
    'express'
    'watch'
  ]
  grunt.registerTask 'test-develop', [
    'env:test'
    'shell:testharness'
    'build'
    'express'
    'watch'
  ]

  grunt.registerTask 'deploy', [
    'shell:deploy'
  ]

  grunt.registerTask 'test', [
    'env:dev' # not using the test db...yet...
    # 'shell:testharness'
    # 'shell:dbclean'
    'mochaTest'
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

  grunt.registerTask 'prod:restart', [
    'env:prod'
    'forever-stop'
    'build:prod'
    'forever-start'
  ]