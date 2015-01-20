module.exports =
  default:
    files: [{
      expand: true
      cwd: 'static/'
      src: ['**']
      dest: './public/'
    }, {
      expand: true
      cwd: './app/'
      src: [
        '**/*.html'
      ]
      flatten: true
      dest: './public/partials/'
    }, {
      expand: true
      src: 'lib/**/*'
      dest: 'public/'
    }]
  cast:
    files: [{
      expand: true
      cwd: 'static/'
      src: ['**']
      dest: 'dist/'
    }, {
      expand: true
      src: 'lib/**/*'
      dest: 'dist/'
    }, {
      expand: true
      src: 'app/**/views/*.html'
      dest: 'dist/partials/'
      flatten: true
    }]