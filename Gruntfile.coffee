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
          'src/**/*.coffee'
          'src/**/*.jade'
          # 'test/**/*.coffee'
          # 'chromecast-receiver/src/**/*.coffee'
          # 'chromecast-receiver/src/**/*.jade'
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
    # build receiver files
    # 'build-cast'

    'coffeelint'
    'clean:default'
    'copy:default'
    'coffee:compile'
    # 'ngconstant:development'
  ]

  grunt.registerTask 'build:fast', [
    'coffeelint'
    # 'build-cast'
    'copy:default'
    'coffee:compile'
  ]

  grunt.registerTask 'build:prod', [
    # see README for receiver deployment instructions
    'build-cast'
    # 'shell:package'

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
    'clean:cast'
    'copy:cast'
    'coffee:cast'
    'jade:cast'
    'shell:deploycast'
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