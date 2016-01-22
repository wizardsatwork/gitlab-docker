include ../Maketasks

.PHONY:
	build \
	debug \
	run \
	help

build: env
	@echo "build postgres database ${POSTGRES_CONTAINER_NAME}"
	@docker build \
		-t ${POSTGRES_CONTAINER_NAME} \
		--build-arg POSTGRES_CONTAINER_PORT=${POSTGRES_CONTAINER_PORT} \
		--build-arg PGDATA=${PGDATA} \
		--rm=true \
		. # dot!
	@echo 'build done'

debug: env
	@echo "connecting to container ${POSTGRES_CONTAINER_NAME}"
	@docker run \
		-i \
		-t \
		--entrypoint=sh ${POSTGRES_CONTAINER_NAME}

run: env
	@echo 'starting container'
	@docker run \
		-i \
		-p ${POSTGRES_HOST_PORT}:${POSTGRES_CONTAINER_PORT} \
		${POSTGRES_CONTAINER_NAME}

logs: env
	@echo 'connecting to logs'
	@docker logs -i -P ${POSTGRES_CONTAINER_NAME}

help:
	@echo " \n\
tasks:\n\
\n\
  build - build docker container \n\
  debug - connect to container shell \n\
  run - run container \n\
  help - this help text \n\
"
