HOSTS_DIR=hosts

OPENRESTY_DIR=openresty
REDIS_DIR=redis
POSTGRES_DIR=postgres
GITLAB_DIR=gitlab
REDMINE_DIR=redmine
MONGO_DIR=mongodb
BACKUP_DIR=../backups

.PHONY: \
	help \
	all \
	ips \
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
	mongo \
	mongo-build \
	mongo-run \
	mongo-logs \
	mongo-rm \
	mongo-debug \
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

deploy:
	@${MAKE} \
		env \
		ips \
		build \
		run

env:
	@./bin/create_env.sh

ips:
	@./bin/create_ip_env.sh

build:
	@${MAKE} \
		redis-build \
		postgres-build \
		gitlab-build \
		redmine-build \
		openresty-build

run:
	@${MAKE} \
		redis-run \
		postgres-run \
		ips \
		gitlab-run \
		redmine-run \
		ips \
		openresty-run

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

backup: gitlab-backup redmine-backup
	echo "creating backup"

	mkdir -p ${BACKUP_DIR}

	echo "start copying files"
	cp -rf ./* ${BACKUP_DIR}
	echo "finished copying files"

	echo "committing changes"
	cd ${BACKUP_DIR}; \
	git init && \
	git add -A ./* && \
	git commit -m "backup $$(date +\%Y-\%m-\%d-\%H:\%M:\%S)" ./*

	echo "backup finished"

	${MAKE} ips openresty

init:
	@./bin/init.sh all

init_submodules:
	@./bin/init.sh init_submodules

crontab:
	@./bin/init.sh crontab

update_submodules:
	@./bin/init.sh update_submodules

# POSTGRES tasks

postgres: postgres-build postgres-run postgres-logs

postgres-build:
	@cd ${POSTGRES_DIR}; ./cli.sh build

postgres-run:
	@cd ${POSTGRES_DIR}; ./cli.sh run

postgres-logs:
	@cd ${POSTGRES_DIR}; ./cli.sh logs

postgres-debug:
	@cd ${POSTGRES_DIR}; ./cli.sh debug

postgres-rm:
	@cd ${POSTGRES_DIR}; ./cli.sh remove

postgres-stop:
	@cd ${POSTGRES_DIR}; ./cli.sh stop


# REDIS tasks

redis: redis-build redis-run redis-logs

redis-build:
	@cd ${REDIS_DIR}; ./cli.sh build

redis-run:
	@cd ${REDIS_DIR}; ./cli.sh run

redis-logs:
	@cd ${REDIS_DIR}; ./cli.sh logs

redis-debug:
	@cd ${REDIS_DIR}; ./cli.sh debug

redis-rm:
	@cd ${REDIS_DIR}; ./cli.sh remove

redis-stop:
	@cd ${REDIS_DIR}; ./cli.sh stop


# GITLAB tasks

gitlab: gitlab-run gitlab-logs

gitlab-run:
	@cd ${GITLAB_DIR}; ./cli.sh run

gitlab-build:
	@cd ${GITLAB_DIR}; ./cli.sh build

gitlab-debug:
	@cd ${GITLAB_DIR}; ./cli.sh debug

gitlab-logs:
	@cd ${GITLAB_DIR}; ./cli.sh logs

gitlab-rm:
	@cd ${GITLAB_DIR}; ./cli.sh remove

gitlab-stop:
	@cd ${GITLAB_DIR}; ./cli.sh stop

gitlab-backup:
	@cd ${GITLAB_DIR}; ./cli.sh backup

# OPENRESTY tasks

openresty: openresty-build openresty-run openresty-logs

openresty-build:
	@cd ${OPENRESTY_DIR}; ./cli.sh build

openresty-run:
	@cd ${OPENRESTY_DIR}; ./cli.sh run

openresty-logs:
	cd openresty; ./cli.sh logs

openresty-debug:
	@cd ${OPENRESTY_DIR}; ./cli.sh debug

openresty-rm:
	@cd ${OPENRESTY_DIR}; ./cli.sh remove

openresty-clean:
	@cd ${OPENRESTY_DIR}; ./cli.sh clean

openresty-stop:
	@cd ${OPENRESTY_DIR}; ./cli.sh stop


# REDMINE tasks

redmine: redmine-build redmine-run redmine-logs

redmine-run:
	@cd ${REDMINE_DIR}; ./cli.sh run

redmine-logs:
	@cd ${REDMINE_DIR}; ./cli.sh logs

redmine-build:
	@cd ${REDMINE_DIR}; ./cli.sh build

redmine-debug:
	@cd ${REDMINE_DIR}; ./cli.sh debug

redmine-rm:
	@cd ${REDMINE_DIR}; ./cli.sh remove

redmine-stop:
	@cd ${REDMINE_DIR}; ./cli.sh stop

redmine-backup:
	@cd ${REDMINE_DIR}; ./cli.sh backup


# MONGODB tasks

mongo: mongo-build mongo-run mongo-logs

mongo-run:
	@cd ${MONGO_DIR}; ./cli.sh run

mongo-logs:
	@cd ${MONGO_DIR}; ./cli.sh logs

mongo-build:
	@cd ${MONGO_DIR}; ./cli.sh build

mongo-debug:
	@cd ${MONGO_DIR}; ./cli.sh debug

mongo-rm:
	@cd ${MONGO_DIR}; ./cli.sh remove

mongo-stop:
	@cd ${MONGO_DIR}; ./cli.sh stop

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
