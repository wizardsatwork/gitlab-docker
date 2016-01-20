build:
	docker build -t magic-postgres --rm=true .

debug:
	docker run -i -t --entrypoint=sh magic-postgres

run:
	docker run -i -P magic-postgres

help:
	@echo " \n\
tasks:\n\
\n\
  build - build docker container \n\
  debug - connect to container shell \n\
  run - run container \n\
  help - this help text \n\
"
