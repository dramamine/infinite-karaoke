module.exports = 
  default:
    expand: true
    cwd: './app/'
    src: ['**'] # warning: this copies over the whole lib directory
    dest: './public/'