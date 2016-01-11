.PHONY: \
	all \
	stop \
	update \
	run

all: run

stop:
	@docker stop gitlab

remove:
	@docker rm -f gitlab || echo "container does not exist"

update: remove
	@echo 'start update'
	@docker pull gitlab/gitlab-ce:latest
	${MAKE} run

run:
	@docker rm -f gitlab || echo "container not started"
	@echo "removed gitlab container"
	@docker run --detach \
		--hostname wizard23-DevRock2 \
		--publish 0.0.0.0:443:443 --publish 0.0.0.0:80:80 --publish 0.0.0.0:2222:22 \
 		--name gitlab \
 		--restart always \
 		--volume /srv/gitlab/config:/etc/gitlab \
		--volume /srv/gitlab/logs:/var/log/gitlab \
		--volume /srv/gitlab/data:/var/opt/gitlab \
		gitlab/gitlab-ce:latest
	@echo "started docker container"

help:
	@echo " \
Usage: \n\
  # run docker container, exposing port 80, 443 and 2222 for ssh \n\
  # todo: replace 2222 with 22 for machine that has no ssh installed natively. \n\
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
