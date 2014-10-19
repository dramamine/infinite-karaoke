module.exports =
  express:
    files: '<%= targets.src %>'
    tasks: [
      'build'
      'express'
    ]
    options:
      spawn: false