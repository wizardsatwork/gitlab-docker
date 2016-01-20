.PHONY: \
	all \
	stop \
	update \
	run

all: run

stop:
	@docker stop gitlab

remove:
	@docker rm -f gitlab && echo "removed container" || echo "container does not exist"

update: remove
	@echo 'start update'
	@docker pull gitlab/gitlab-ce:latest
	${MAKE} run

run: remove
	@docker run --detach \
		--hostname gitlab.wiznwit.com \
		--publish 0.0.0.0:443:443 --publish 0.0.0.0:80:80 --publish 0.0.0.0:2222:22 \
		--name gitlab \
		--restart always \
		--volume ./config:/etc/gitlab \
		--volume ./lots:/var/log/gitlab \
		--volume ./data:/var/opt/gitlab \
		gitlab/gitlab-ce:latest
	@echo "started docker container"

help:
	@echo " \
Usage: \n\
	# run docker container, exposing port 80, 443 and 2222 for ssh \n\
	make \n\
\n\
	# stop container \n\
	make stop \n\
\n\
	# remove container \n\
	make remove \n\
\n\
	# update container \n\
	make update \n\
\n\
"
