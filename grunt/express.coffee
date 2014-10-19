module.exports = {
  options:
    opts: ['/usr/bin/coffee']
    script: '<%= package.main %>'
    delay: 1

  # prob don't need this
  watch:
    background: true
}