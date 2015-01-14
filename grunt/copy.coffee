module.exports =
  default:
    expand: true
    cwd: './app/'
    src: ['**'] # warning: this copies over the whole lib directory
    dest: './public/'
  cast:

    files: [{
      expand: true
      cwd: './chromecast-receiver/app'
      src: ['**']
      dest: './chromecast-receiver/'
    },{
        expand: true
        cwd: './app/lib'
        src: ['**']
        dest: './chromecast-receiver/dist/lib/'
      }
    ]

