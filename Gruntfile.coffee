module.exports = (grunt) ->
  
  #load tasks
  require('load-grunt-tasks') grunt

  #config
  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    express:
      options:
        cmd: 'coffee'
        script: '<%= pkg.main %>'
        delay: 1
      dev: {}

    # coffeelint:
    #   options:
    #     configFile: 'config/coffeelint.json'
    #   src: ['*.coffee','src/**/*.coffee','test/**/*.coffee','generator/**/*.coffee']

    # mochaTest:
    #   src: ['test/**/*.coffee']
    #   options:
    #     reporter: 'nyan'
    #     clearRequireCache: true
    #     require: 'coffee-script'

    # coffee:
    #   options:
    #     join: true
    #   default:
    #     src: ['src/admin/angular.coffee']
    #     dest: 'public/js/main.js'

    #coffeeify:
    #  files:
    #    src: 'src/public/**/*.coffee'
    #    dest: 'public/js/main.js'

    # copy:
    #   main:
    #     expand: true
    #     cwd: 'src/public/views/'
    #     src: '**/*.html'
    #     dest: 'public/views/'
    #     filter: 'isFile'
    #   modules:
    #     expand: true
    #     cwd: 'src/modules/'
    #     src: '**/*.html'
    #     dest: 'public/views/'
    #     filter: 'isFile'

    watch:
      options:
        spawn: false
        livereload: true

      # coffeelint:
      #   tasks: ['coffeelint']
      #   files: '<%= coffeelint.src %>'

      # mochaTest:
      #   tasks: ['mochaTest']
      #   files: ['<%= mochaTest.src %>', 'src/**/*.coffee']

      # coffee:
      #   tasks: ['coffee:default']
      #   files: '<%= coffee.default.src %>'

      #coffeeify:
      #  tasks: ['coffeeify']
      #  files: '<%= coffeeify.files.src %>'

      # copyModules:
      #   tasks: ['copy:modules']
      #   files: '<%= copy.modules.cwd %><%= copy.modules.src %>'

      # copy:
      #   tasks: ['copy:main']
      #   files: '<%= copy.main.cwd %><%= copy.main.src %>'

      express:
        tasks: ['express']
        files: ['src/**/*.coffee','src/**/*.jade']

  #end config

  #force options
  #grunt.option 'force', true

  #on watch
#  grunt.event.on 'watch', (action, filepath, target) ->
    #console.log '\n--', action, filepath, target

    # if target == 'coffeelint'
    #   grunt.config 'coffeelint.src', filepath

    # if target == 'mochaTest'
    #   if filepath.match('test/')
    #     grunt.config 'mochaTest.src', filepath
    #   else if filepath.match('src/')
    #     grunt.config 'mochaTest.src', filepath.replace( 'src','test' )
    #   else
    #     console.log 'wat do?'
  
    # if target == 'copy'
    #   grunt.config 'copy.main.src', filepath.replace('src/public/views/', '')
  


  #end on watch

  #tasks
  grunt.registerTask 'default', [
    'express'
    'watch'
    ]
