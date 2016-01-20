# redis container

# Build

```bash
$ make build
```

# Usage

Start a basic redis server, protected by a password,
listening on port  by running the following:

```
$ make run
```

Then start your app's container while **linking** it to the redis
container you just created giving it access to it.

```
$ docker run --name some-app --link magic-redis:magic-redis -d application-that-uses-redis
```

Your app will now be able to access `REDIS_PORT_6379_TCP_ADDR`
and `REDIS_PORT_6379_TCP_PORT` environment variables.
