
build:
	docker build -t="magic/resty" ./openresty;
	docker build -t="magic/redis" ./redis;

run:
	docker run magic/resty;
	docker run magic/redis;


install:
	wget https://openresty.org/download/ngx_openresty-1.9.7.1.tar.gz ./openresty
