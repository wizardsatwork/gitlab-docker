include ../Maketasks

.PHONY:
	build \
	debug \
	run \
	help \
	env

debug: env
	@echo "connecting to container ${POSTGRES_CONTAINER_NAME}"
	@docker run \
		-i \
		--name ${POSTGRES_CONTAINER_NAME} \
		--entrypoint=sh ${POSTGRES_CONTAINER_NAME}

run: env rm
	@echo "starting container"
	@docker run \
		-i \
		--detach \
		--name ${POSTGRES_CONTAINER_NAME} \
		-p ${POSTGRES_HOST_PORT}:${POSTGRES_CONTAINER_PORT} \
		${POSTGRES_CONTAINER_NAME}

rm: env
	@echo "removing container"
	@docker rm -f ${POSTGRES_CONTAINER_NAME} || echo "container does not exist"

logs: env
	@echo "connecting to logs"
	@docker logs -f ${POSTGRES_CONTAINER_NAME}

help:
	@echo " \n\
tasks:\n\
\n\
  build - build docker container \n\
  debug - connect to container shell \n\
  run - run container \n\
  help - this help text \n\
"
