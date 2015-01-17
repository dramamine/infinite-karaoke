module.exports =
  default:
    files: [{
      expand: true
      cwd: './app/'
      src: [
        'css/**'
        'img/**'
        'lib/**'
      ]
      dest: './public/'
    }, {
      expand: true
      cwd: './app/components/'
      src: [
        '**/*.html'
      ]
      flatten: true
      dest: './public/partials/'
    }]
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
    }]

