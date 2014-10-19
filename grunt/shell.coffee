module.exports = 
  options:
    stdout: true
    stderr: true

  target: 
    command: [
      'echo "copying libs..."'
      # 'scp -r ./public/lib ocean:/var/www/infinite-karaoke/public/'
      'echo "copying css..."'
      'scp -r ./public/css ocean:/var/www/infinite-karaoke/public/'
      'echo "copying imgs..."'
      'scp -r ./public/img ocean:/var/www/infinite-karaoke/public/'

      # handle everything on the server from the makefile
      'ssh root@104.131.72.219 "cd /var/www/infinite-karaoke/public/ && make:deploy'
    ].join('&&')