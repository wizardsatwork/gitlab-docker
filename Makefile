HOSTS_DIR = hosts

.PHONY: \
	help \
	all \
	env \
	deploy \
	build \
	run \
	stop \
	ps \
	postgres \
	postgres-build \
	postgres-run \
	postgres-logs \
	postgres-rm \
	postgres-debug \
	redis \
	redis-build \
	redis-run \
	redis-logs \
	redis-rm \
	redis-debug \
	openresty \
	openresty-build \
	openresty-run \
	openresty-logs \
	openresty-rm \
	openresty-debug \
	gitlab \
	gitlab-build \
	gitlab-run \
	gitlab-logs \
	gitlab-rm \
	gitlab-debug \
	redmine \
	redmine-build \
	redmine-run \
	redmine-logs \
	redmine-rm \
	redmine-debug \
	hosts \
	hosts-build \
	hosts-run

# general

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
	@${MAKE} gitlab-build
	@${MAKE} redmine-build

run:
	@${MAKE} postgres-run
	@${MAKE} redis-run
	@${MAKE} openresty-run
	@${MAKE} gitlab-run
	@${MAKE} redmine-run

clean:
	@echo "removing configuration files:"
	@echo "$$(ls -l ./**/ENV.sh)"
	@rm -f ./**/ENV.sh

ps:
	@docker ps

stop:
	@${MAKE} -j5 \
		postgres-stop \
		redis-stop \
		openresty-stop \
		gitlab-stop \
		redmine-stop

# POSTGRES tasks

postgres: postgres-build postgres-run postgres-logs

postgres-build:
	@cd postgres; ./cli.sh build

postgres-run:
	@cd postgres; ./cli.sh run

postgres-logs:
	@cd postgres; ./cli.sh logs

postgres-debug:
	@cd postgres; ./cli.sh debug

postgres-rm:
	@cd postgres; ./cli.sh rm

postgres-stop:
	@cd postgres; ./cli.sh stop


# REDIS tasks

redis: redis-build redis-run redis-logs

redis-build:
	@cd redis; ./cli.sh build

redis-run:
	@cd redis; ./cli.sh run

redis-logs:
	@cd redis; ./cli.sh logs

redis-debug:
	@cd redis; ./cli.sh debug

redis-rm:
	@cd redis; ./cli.sh rm

redis-stop:
	@cd redis; ./cli.sh stop


# GITLAB tasks

gitlab: gitlab-run gitlab-logs

gitlab-run:
	@cd gitlab; ./cli.sh run

gitlab-build:
	@cd gitlab; ./cli.sh build

gitlab-debug:
	@cd gitlab; ./cli.sh debug

gitlab-logs:
	@cd gitlab; ./cli.sh logs

gitlab-rm:
	@cd gitlab; ./cli.sh rm

gitlab-stop:
	@cd gitlab; ./cli.sh stop

# OPENRESTY tasks

openresty: openresty-build openresty-run openresty-logs

openresty-build:
	@cd openresty; ./cli.sh build

openresty-run:
	@cd openresty; ./cli.sh run

openresty-logs:
	cd openresty; ./cli.sh logs

openresty-debug:
	@cd openresty; ./cli.sh debug

openresty-rm:
	@cd openresty; ./cli.sh rm

openresty-stop:
	@cd openresty; ./cli.sh stop


# REDMINE tasks

redmine: redmine-run redmine-logs

redmine-run:
	@cd redmine; ./cli.sh run

redmine-logs:
	@cd redmine; ./cli.sh logs

redmine-build:
	@cd redmine; ./cli.sh build

redmine-debug:
	@cd redmine; ./cli.sh debug

redmine-rm:
	@cd redmine; ./cli.sh rm

redmine-stop:
	@cd redmine; ./cli.sh stop

# host tasks

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


# help output

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
