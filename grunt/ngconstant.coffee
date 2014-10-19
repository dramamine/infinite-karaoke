module.exports = (grunt) ->
  options: 
    dest: 'public/js/config.js'
    name: 'config'
  development:
    constants:
      DEBUG: true
  production:
    constants:
      DEBUG: false