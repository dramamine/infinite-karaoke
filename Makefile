all:
	npm install && npm prune
	bower install && bower prune


deploy:
	npm install --production && npm prune --production
	bower install --production --allow-root && bower prune --allow-root--production

	git reset --hard HEAD
	git pull origin master

	grunt prod:restart
