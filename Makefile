include ./Maketasks

HOSTS_DIR = hosts

.PHONY: \
	help \
	all \
	ps \
	postgres \
	postgres-build \
	postgres-run \
	postgres-logs \
	redis \
	redis-build \
	redis-run \
	redis-logs \
	openresty \
	openresty-build \
	openresty-run \
	openresty-logs \
	gitlab \
	gitlab-build \
	gitlab-run \
	gitlab-logs \
	redmine \
	redmine-build \
	redmine-run \
	redmine-logs \
	hosts \
	hosts-build \
	hosts-run

all: help

env:
	@./create_env.sh

deploy:
	@${MAKE} postgres redis openresty
	@${MAKE} gitlab
	@${MAKE} remove-hashes

build:
	@${MAKE} -j2 postgres-build redis-build
	@${MAKE} openresty-build

run:
	@${MAKE} postgres-run
	@${MAKE} redis-run
	@${MAKE} openresty-run
	@${MAKE} gitlab-run

postgres: postgres-build postgres-run

postgres-build:
	@cd postgres; ./cli.sh build

postgres-run:
	@cd postgres; ./cli.sh run

redis: redis-build redis-run

redis-build:
	@cd redis; ./cli.sh build

redis-run:
	@cd redis; ./cli.sh run

gitlab: gitlab-run

gitlab-run:
	@cd gitlab; ./cli.sh run

openresty: openresty-build openresty-run

openresty-build:
	@cd openresty; ./cli.sh build

openresty-run:
	@cd openresty; ./cli.sh run


redmine: redmine-run redmine-logs

redmine-run:
	@cd redmine; ./cli.sh run

redmine-logs:
	@cd redmine; ./cli.sh logs

stop-all:
	@cd gitlab; ./cli.sh stop
	@cd redmine; ./cli.sh stop
	@cd openresty; ./cli.sh stop
	@cd redis; ./cli.sh stop
	@cd postgres; ./cli.sh stop

hosts:
	@echo "building hosts"
	@for dir in $$(ls ${HOSTS_DIR}); do \
		host_dir=${HOSTS_DIR}/$$dir; \
		if [ -d $$host_dir ]; then \
			echo "building host $$dir"; \
			cd $$host_dir; \
			${MAKE} build; \
		else \
			echo "not a host directory $$host_dir"; \
		fi; \
	done;

hosts-status:
	@echo "getting host status"
	@for dir in $$(ls ${HOSTS_DIR}); do \
		echo "host: $$dir git status"; \
		cd ${HOSTS_DIR}/$$dir; \
		git status; \
	done;

hosts-update:
	@echo "updating hosts"
	@for dir in $$(ls ${HOSTS_DIR}); do \
		echo "host: $$dir git pull"; \
		cd ${HOSTS_DIR}/$$dir; \
		git pull; \
		echo "host: $$dir update done"; \
	done;

hosts-install:
	@echo "installing host dependencies"
	@for dir in $$(ls ${HOSTS_DIR}); do \
		echo "host: $$dir install dependencies"; \
		cd ${HOSTS_DIR}/$$dir; \
		npm install; \
		echo "host: $$dir dependencies installed"; \
	done;

clean:
	@echo "removing configuration files:"
	@echo "$$(ls -l ./**/ENV.sh)"
	@rm -f ./**/ENV.sh

ps:
	@docker ps

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
