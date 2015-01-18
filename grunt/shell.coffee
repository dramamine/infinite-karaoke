module.exports =
  options:
    stdout: true
    stderr: true

  backup:
    command: [
      'mongoexport -h dbh36.mongolab.com:27367 -d infinite -c tracks -u infinite -p "sm<hC3Jjz86&Q68" -o data/backup/tracks.json'
      'mongoexport -h dbh36.mongolab.com:27367 -d infinite -c videos -u infinite -p "sm<hC3Jjz86&Q68" -o data/backup/videos.json'
      'mongoexport -h dbh36.mongolab.com:27367 -d infinite -c lyrics -u infinite -p "sm<hC3Jjz86&Q68" -o data/backup/lyrics.json'
      'mongoexport -h dbh36.mongolab.com:27367 -d infinite -c comments -u infinite -p "sm<hC3Jjz86&Q68" -o data/backup/comments.json'
    ].join('&&')

  dbclean:
    command: [
     #  'mongoimport --drop --collection tracks --file data/testdata/tracks.json --db infinite --dbpath test/data'
      'mongoimport --drop --collection tracks --file data/testdata/tracks.json'
      'mongoimport --drop --collection videos --file data/testdata/videos.json'
      'mongoimport --drop --collection lyrics --file data/testdata/lyrics.json'
      'mongoimport --drop --collection comments --file data/testdata/comments.json'
    ].join('&&')

  testharness:
    options:
      async: true
      stdout: false
      # stderr: true

    command: [
      'mongod --dbpath test/data --port 12345 --quiet'
    ].join('&&')

  deploy:
    command: [
      # 'echo "copying libs..."'
      # 'scp -r ./public/lib ocean:/var/www/infinite-karaoke/public/'
      'echo "copying css..."'
      'scp -r ./public/css ocean:/var/www/infinite-karaoke/public/'
      'echo "copying imgs..."'
      'scp -r ./public/img ocean:/var/www/infinite-karaoke/public/'

      # handle everything on the server from the makefile
      'ssh root@104.131.72.219 "cd /var/www/infinite-karaoke/public/ && make:deploy'
    ].join('&&')

  cleanup:
    command: 'mongod --dbpath test/data --shutdown'

  # for packaging up the receiver files
  # (not using this currently)
  package:
    command: [
        'cd chromecast-receiver'
        'zip -r builds/receiver.zip dist/*'
      ].join('&&')
