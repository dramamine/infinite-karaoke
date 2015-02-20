module.exports =
  dev:
    options:
      style: 'expanded'
      compass: true
    files:
      'static/css/app.css': '<%= targets.styles %>'

  dist:
    options:
      style: 'compressed'
      compass: true
    files:
      'static/css/app.css': '<%= targets.styles %>'
