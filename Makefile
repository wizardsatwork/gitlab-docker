OUT_DIR = ./out
SRC_DIR = ./src
LIB_NAME = resty

.PHONY: \
	nginx-build \
	moon-build \
	docker-build \
	build \
	moon-watch \
	server \
	docker-run
	clean \
	lint \
	help \
	;

nginx-build:
	mkdir -p ${OUT_DIR}/nginx;
	cp -r nginx/* ${OUT_DIR}/nginx/;

moon-build:
	mkdir -p ${OUT_DIR}/lua;
	moonc \
		-o ${OUT_DIR}/lua/${LIB_NAME}.lua \
		src/${LIB_NAME}.moon \
	;

docker-build:
	docker build -t="magic/${LIB_NAME}" .;

build: nginx-build moon-build docker-build

moon-watch:
	moonc \
		-w src/* \
		-o ${OUT_DIR}/lua/${LIB_NAME}.lua \
		${SRC_DIR}/${LIB_NAME}.moon
	;

server:
	lapis server

moon-lint:
	moonc -l ${SRC_DIR}/${LIB_NAME}.moon

docker-run:
	docker run magic/${LIB_NAME};

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

