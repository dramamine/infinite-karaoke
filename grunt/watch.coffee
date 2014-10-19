module.exports =
  express:
    files: '<%= targets.src %>'
    tasks: [
      'build:fast'
      'express'
    ]
    options:
      spawn: false