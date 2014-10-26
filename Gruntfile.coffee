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
          'app/**/*.html'
          'src/**/*.coffee'
          'src/**/*.jade'
          'test/**/*.coffee'
        ]
      gruntfile: ['Gruntfile.coffee']
      bower: '<json:bower.json>'


  grunt.registerTask 'build', [
    'coffeelint'
    'clean'
    'copy'
    'ngconstant:development'
  ]

  grunt.registerTask 'build:fast', [
    'coffeelint'
    'copy'
  ]

  grunt.registerTask 'build:prod', [
    'coffeelint'
    'clean'
    'copy'
    'ngconstant:production'
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

  grunt.registerTask 'forever-start', [
    'env:prod'
    'ngconstant:production'
    'forever:server:start'
  ]

  grunt.registerTask 'forever-stop', [
    'forever:server:stop'
  ]
  grunt.registerTask 'forever-restart', [
    'forever:server:restart'
  ]