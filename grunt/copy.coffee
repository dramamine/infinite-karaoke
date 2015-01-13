module.exports =
  default:
    expand: true
    cwd: './app/'
    src: ['**'] # warning: this copies over the whole lib directory
    dest: './public/'
  cast:
    expand: true
    cwd: './chromecast-receiver/app'
    src: ['**']
    dest: './chromecast-receiver/'