OUT_DIR = ./out
SRC_DIR = ./src
NGINX_SRC_DIR = ${SRC_DIR}/nginx
LUA_SRC_DIR = ${SRC_DIR}/lua
LIB_NAME = resty

.PHONY: \
	nginx-build \
	docker-build \
	docker-run
	build \
	moon-build \
	moon-watch \
	moon-lint \
	server \
	clean \
	help

asset-build:
	mkdir -p ${OUT_DIR}
	cp -r ${SRC_DIR}/assets ${OUT_DIR}

nginx-build:
	mkdir -p ${OUT_DIR}/nginx
	cp -r ${NGINX_SRC_DIR}/* ${OUT_DIR}/nginx/

moon-build:
	mkdir -p ${OUT_DIR}/lua;
	cd ${LUA_SRC_DIR} && moonc \
		-t ../../${OUT_DIR}/lua/ \
		./*

moon-watch:
	moonc \
		-w src/* \
		-o ${OUT_DIR}/lua/${LIB_NAME}.lua \
		${LUA_SRC_DIR}/${LIB_NAME}.moon

moon-lint:
	moonc -l ${LUA_SRC_DIR}/*

docker-build:
	docker build -t="magic/${LIB_NAME}" .

docker-run:
	docker run \
		--name ${LIB_NAME} \
		--rm \
		magic/${LIB_NAME}

# removes ALL docker containers
docker-rm-containers:
	containers=$(shell docker ps -a -q)
ifneq (${containers}"t","t")
	@echo "removing containers ${containers}" && \
	docker rm ${containers}
endif

# removes ALL docker images
docker-rm-images:
	docker rmi $(shell docker images -q)

docker-connect:
	docker run -it magic/${LIB_NAME} sh

docker-rm:
	docker rm -f resty

# start lua lapis server in development mode
server-dev:
	lapis server development

# start lua lapis server in production mode
server-production:
	lapis server production

build: asset-build nginx-build moon-build docker-build

all: build docker-run

clean:
	rm -fr \
		${OUT_DIR}

help:
	@echo "\
nginx-build - build nginx config files to OUT_DIR/nginx \n\
moon-build - build moonscript to OUT_DIR/lua \n\
docker-build - build docker container based on files in out \n\
build - build nginx and lua, then build docker container\n\
moon-watch - watch changes to moon files and recompile out directory on changes \n\
server-dev - starts a lapis server in development mode (not implemented yet) \n\
server-production - starts a lapis server in production mode (not implemented yet) \n\
docker-run - runs the prebuilt docker container \n\
clean - removes the out directory \n\
lint - lints the moonscript sources \n\
"
