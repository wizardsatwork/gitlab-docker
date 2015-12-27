
build:
	docker build -t="magic/resty" ./openresty;
	docker build -t="magic/redis" ./redis;

run:
	docker run magic/resty;
	docker run magic/redis;
