all:
	npm install && npm prune
	bower install && bower prune

  
deploy:
	git pull
	npm install && npm prune
	bower install && bower prune

	cd /var/www/infinite-karaoke/

	

	grunt forever-stop
	grunt build:prod
	grunt forever-start