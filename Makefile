all: mail-base dovecot rainloop owncloud

.PHONY: mail-base dovecot rainloop owncloud run-dovecot run-rainloop run-owncloud

mail-base: 
	cd mail-base; docker build --no-cache -t mail-base .

dovecot: mail-base
	cd dovecot; docker build -t dovecot:2.1.7 .

rainloop: dovecot
	cd rainloop; docker build -t rainloop:1.6.9 .

mailpile: dovecot
	cd mailpile; docker build -t mailpile:latest .

owncloud: dovecot
	cd owncloud; docker build -t owncloud:7.0.2 .

run-dovecot:
	docker run \
		--name mailstack-dovecot \
		-d -p 0.0.0.0:25:25 -p 0.0.0.0:587:587 -p 0.0.0.0:143:143 -v /srv/vmail:/srv/vmail dovecot:2.1.7

run-rainloop:
	docker run \
		--name mailstack-rainloop \
		-d -p 127.0.0.1:33100:80 rainloop:1.6.9

run-mailpile:
	docker run \
		--name mailstack-mailpile \
		-d -p 127.0.0.1:33411:33411 mailpile:latest

run-owncloud:
	docker run \
		--name mailstack-owncloud \
		-d -p 127.0.0.1:33200:80 -v /srv/owncloud:/var/www/owncloud/data owncloud:7.0.2 

run-all: run-dovecot run-rainloop run-owncloud

stop-dovecot:
	docker stop mailstack-dovecot
stop-rainloop:
	docker stop mailstack-rainloop
stop-owncloud:
	docker stop mailstack-owncloud

stop-all: stop-dovecot stop-rainloop stop-owncloud

rm-dovecot:
	docker rm mailstack-dovecot
rm-rainloop:
	docker rm mailstack-rainloop
rm-owncloud:
	docker rm mailstack-owncloud

rm-all: rm-dovecot rm-rainloop rm-owncloud
