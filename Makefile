OUT_DIR = ./out
SRC_DIR = ./src
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
	help \
	;

nginx-build:
	mkdir -p ${OUT_DIR}/nginx;
	cp -r nginx/* ${OUT_DIR}/nginx/;

moon-build:
	mkdir -p ${OUT_DIR}/lua;
	cd ./src/ && moonc \
		-t ../${OUT_DIR}/lua/ \
		./* \
	;

moon-watch:
	moonc \
		-w src/* \
		-o ${OUT_DIR}/lua/${LIB_NAME}.lua \
		${SRC_DIR}/${LIB_NAME}.moon
	;

moon-lint:
	moonc -l ${SRC_DIR}/*

docker-build:
	docker build -t="magic/${LIB_NAME}" .;

docker-run:
	docker run magic/${LIB_NAME};

server:
	lapis server

build: nginx-build moon-build docker-build

all: build docker-run

clean:
	rm -fr \
		${OUT_DIR} \
	;

help:
	@echo "\
nginx-build - build nginx config files to OUT_DIR/nginx \n\
moon-build - build moonscript to OUT_DIR/lua \n\
docker-build - build docker container based on files in out \n\
build - build nginx and lua, then build docker container\n\
moon-watch - watch changes to moon files and recompile out directory on changes \n\
server - starts a lapis server (not implemented yet) \n\
docker-run - runs the prebuilt docker container \n\
clean - removes the out directory \n\
lint - lints the moonscript sources \n\
";

