REDIS_DIR = ./redis
OPENRESTY_DIR = ./openresty
VENDOR_DIR = vendor
OPENRESTY_TAR_FILE = ngx_openresty-1.9.7.1.tar.gz
REDIS_TAR_FILE = redis-stable.tar.gz

OPENRESTY_FULL_PATH = ${OPENRESTY_DIR}/${VENDOR_DIR}/${OPENRESTY_TAR_FILE}
REDIS_FULL_PATH = ${REDIS_DIR}/${VENDOR_DIR}/${REDIS_TAR_FILE}

build-openresty:
	docker build -t="magic/resty" ${OPENRESTY_DIR};

build-redis:
	docker build -t="magic/redis" ${REDIS_DIR};

build: ; ${MAKE} -j2 build-openresty build-redis

run-openresty:
	docker run magic/resty;

run-redis:
	docker run magic/redis;

run: ; ${MAKE} -j2 run-openresty run-redis

install-openresty:
	mkdir -p ${OPENRESTY_DIR}/${VENDOR_DIR}
	wget \
		-O ${OPENRESTY_FULL_PATH} \
		https://openresty.org/download/${OPENRESTY_TAR_FILE} \
		--no-clobber \
	;

install: ; ${MAKE} -j1 install-openresty

clean:
	rm -fr \
		${OPENRESTY_DIR}/${VENDOR_DIR}/ \
		${REDIS_DIR}/${VENDOR_DIR}/ \
	;
