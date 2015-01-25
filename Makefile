all:
	npm install && npm prune
	bower install && bower prune


deploy:
	git reset --hard HEAD
	git pull origin master

	npm install --production && npm prune --production
	bower install --production --allow-root && bower prune --allow-root --production

	grunt prod:restart
