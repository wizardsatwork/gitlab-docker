REDIS_DIR = ./redis
OPENRESTY_DIR = ./openresty
VENDOR_DIR = vendor
OPENRESTY_TAR_FILE = ngx_openresty-1.9.7.1.tar.gz
REDIS_TAR_FILE = redis-stable.tar.gz

OPENRESTY_FULL_PATH = ${OPENRESTY_DIR}/${VENDOR_DIR}/${OPENRESTY_TAR_FILE}
REDIS_FULL_PATH = ${REDIS_DIR}/${VENDOR_DIR}/${REDIS_TAR_FILE}

build:
	docker build -t="magic/resty" ${OPENRESTY_DIR};
	docker build -t="magic/redis" ${REDIS_DIR};

run:
	docker run magic/resty;
	docker run magic/redis;

bla:
	@test -d ${OPENRESTY_DIR} || echo "does not exist"

install-openresty:
	mkdir -p ${OPENRESTY_DIR}/${VENDOR_DIR}
	wget \
		-O ${OPENRESTY_FULL_PATH} \
		https://openresty.org/download/${OPENRESTY_TAR_FILE} \
		--no-clobber \
	;

install-redis:
	mkdir -p ${REDIS_DIR}/${VENDOR_DIR}
	wget \
		-O ${REDIS_FULL_PATH} \
		http://download.redis.io/${REDIS_TAR_FILE} \
		--no-clobber \
	;

install: ; ${MAKE} -j2 install-redis install-openresty

clean:
	rm -fr \
		${OPENRESTY_DIR}/${VENDOR_DIR}/ \
		${REDIS_DIR}/${VENDOR_DIR}/ \
	;
