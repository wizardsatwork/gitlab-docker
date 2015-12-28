OUT_DIR = ./out
SRC_DIR = ./src
LIB_NAME = resty

.PHONY: \
	build \
	docker-build \
	watch \
	server \
	install \
	install-lapis \
	install-moonscript \
	clean \
	lint \
	;


build:
	mkdir -p ${OUT_DIR};
	moonc \
		-o ${OUT_DIR}/${LIB_NAME}.lua \
		src/${LIB_NAME}.moon \
	;

docker-build:
	docker build -t="magic/${LIB_NAME}" .;

watch:
	moonc \
		-w src/app.moon \
		-o ${OUT_DIR}/${LIB_NAME}.lua \
		${SRC_DIR}/${LIB_NAME}.moon
	;

server:
	lapis server

lint:
	moonc -l ${SRC_DIR}/${LIB_NAME}.moon

run:
	docker run magic/${LIB_NAME};

clean:
	rm -fr \
		${OUT_DIR} \
	;
