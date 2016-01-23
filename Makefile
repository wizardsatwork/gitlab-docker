include ./Maketasks

.PHONY: \
	help \
	all \
	postgres \
	postgres-build \
	postgres-run \
	redis \
	redis-build \
	redis-run \
	openresty \
	openresty-build \
	openresty-run \
	gitlab

all: help

deploy:
	@${MAKE} postgres redis openresty
	@${MAKE} gitlab
	@${MAKE} remove-hashes

build:
	@${MAKE} -j2 postgres-build redis-build
	@${MAKE} openresty-build
	@${MAKE} gitlab-build

run:
	@${MAKE} -j2 postgres-run redis-run
	@${MAKE} openresty-run
	@${MAKE} gitlab-run

postgres: postgres-build postgres-run

postgres-build:
	@cd ./postgres; \
	@${MAKE} build

postgres-run:
	@cd ./postgres; \
	@${MAKE} run

redis: redis-build redis-run

redis-build:
	@cd redis; \
	@${MAKE} build

redis-run:
	@cd redis; \
	@${MAKE} run

gitlab: gitlab-build gitlab-run

gitlab-build:
	@cd gitlab; \
	@${MAKE} build

gitlab-run:
	@cd gitlab; \
	@${MAKE} run

openresty: openresty-build openresty-run

openresty-build:
	@cd openresty
	@${MAKE} build

openresty-run:
	@cd openresty
	${MAKE} run

help:
	@echo "\
Usage \n\
make TASK\n\
	deploy    - runs all build tasks in a row, \n\
	build-all - builds all containers \n\
	run-all   - runs all containers \n\
\n\
	postgres  - build and run the postgres container \n\
	redis     - build and run the redis container \n\
	openresty - build and run the openresty container \n\
	gitlab    - build and run gitlab \n\
	soon: redmine   - build and run redmine \n\
\n\
	each of the tasks has a -build and a -run subtask: \n\
	postgres-build, redis-run. \n\
\n\
	help      - this help text \n\
"
