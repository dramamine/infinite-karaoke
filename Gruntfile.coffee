module.exports = (grunt) ->
  
  #load tasks
  require('load-grunt-tasks') grunt

  
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-shell'
  grunt.loadNpmTasks 'grunt-forever'

  #config
  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    # express:
    #   options:
    #     cmd: 'coffee'
    #     script: '<%= pkg.main %>'
    #     delay: 1
    #   dev: {}


    # pkg: '<json:package.json>'
    # bower: '<json:bower.json>'

    targets:
      src: [
        'src/**/*.coffee'
        'public/**/*.coffee'
        'public/**/*.jade'
      ]
      # unittest: [
      #   'test/unit/**/*.coffee'
      #   'test/helpers/**/*.coffee'
      # ]
      # integrationtest: ['test/integration/**/*.coffee']
      gruntfile: ['Gruntfile.coffee']

    coffeelint:
      all: '<%= targets %>'


    jade:
      options:
        pretty: true
      src: ['src/**/*.jade']

    express:
      options:
        cmd: 'coffee'
        script: '<%= pkg.main %>'
        delay: 1

      # dev:
      #   options:
      #     background: false

      # prob don't need this
      watch:
        background: true


    ngconstant:
      options: 
        dest: 'public/js/config.js'
        name: 'config'
      development:
        constants:
          DEBUG: true
      production:
        constants:
          DEBUG: false


    watch:
      express:
        files: '<%= targets.src %>'
        tasks: 'express'
        options:
          spawn: false

    forever:
      server:
        options:
          command: 'coffee'
          index: '<%= pkg.main %>'

    shell:
      file: 'data/marten.db',
      setupScript: 'data/sqlite_setup.sql',
      testScript: 'test/sqliteSpec.sql'

      options:
        stdout: true
        stderr: true

      dbsetup:
        command: 'rm <%= shell.file %> && sqlite3 <%= shell.file %> < <%= shell.setupScript %>'

      dbtest:

        command: 'sqlite3 <%= shell.file %> < <%= shell.testScript %>'

        # files:
        #   "./chromecast-receiver/receiver.html": "./views/receiver.jade"
          
        # options: 
        #   data: 
        #     debug: false
        #     
        #  
          
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

    # watch:
    #   coffee:
    #       files: 'src/js/*.coffee'
    #       tasks: ['coffee:compile']
    #   jade:
    #       files: 'src/views/**/*.jade'
    #       tasks: ['jade:compile']

    #   options:
    #     spawn: false
    #     livereload: true
        
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

      # express:
      #   tasks: ['express']
      #   files: ['src/**/*.coffee','src/**/*.jade']

      

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
    # 'coffeelint'
    # 'jade'
    'ngconstant:development'
    'express:watch'
    'watch'
    ]

  grunt.registerTask 'forever-start', [
    'ngconstant:production'
    'forever:server:start'
    ]
  grunt.registerTask 'forever-stop', [
    'forever:server:stop'
    ]
  grunt.registerTask 'forever-restart', [
    'forever:server:restart'
    ]