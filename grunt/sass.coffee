module.exports =
  dev:
    options:
      style: 'expanded'
      compass: true
    files:
      'public/css/app.css': '<%= targets.styles %>'

  dist:
    options:
      style: 'compressed'
      compass: true
    files:
      'public/css/app.css': '<%= targets.styles %>'
