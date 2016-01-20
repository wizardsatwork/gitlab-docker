CONTAINER_NAME = magic-redis
CONTAINER_PORT = 6379

all: build run

build:
	docker build -t ${CONTAINER_NAME} --rm=true .

debug:
	docker run -i -t ${CONTAINER_NAME}

rm:
	@docker rm ${CONTAINER_NAME} || echo 'container does not exist'

run: rm
	docker run \
		--detach \
		--name ${CONTAINER_NAME} \
		-p ${CONTAINER_PORT}:${CONTAINER_PORT} \
		magic-redis

help:
	@echo " \n\
tasks:\n\
\n\
  build - build docker container \n\
  debug - connect to container shell \n\
  run - run container \n\
  rm - remove container \n\
  help - this help text \n\
"
