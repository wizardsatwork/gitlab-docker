import get_redis from require "lapis.redis"

class App extends lapis.Application
  "/": =>
    redis = get_redis!
    redis\set "hello", "world"

    redis\get "hello"
