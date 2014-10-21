module.exports =
  test:
    options:
      reporter: 'spec'
      require: 'coffee-script/register'
      captureFile: 'results.txt'
      quiet: false
    src: ['test/server/*Spec.coffee']