module.exports =
  # express:
  #   files: '<%= targets.src %>'
  #   tasks: [
  #     'build:fast'
  #     'express'
  #   ]
  #   options:
  #     spawn: false

  receiver:
    files: '<%= targets.receiveronly %>'
    tasks: [
      'build:cast'
      'express'
    ]
    options:
      spawn: false
      livereload: true

  coffeescript:
    files: '<%= targets.coffeeonly %>'
    tasks: [
      'coffeelint'
      'coffee:compile'
      'express'
    ]
    options:
      spawn: false
      livereload: true

  frontend:
    files: [
      '<%= targets.templates %>'
      '<%= targets.styles %>'
    ]
    tasks: [
      'sass:dev'
      'express'
    ]
    options:
      spawn: false
      livereload: true

  gruntfile:
    files: [
      'Gruntfile.coffee'
      'grunt/*.coffee'
    ]
    options:
      interrupt: true
