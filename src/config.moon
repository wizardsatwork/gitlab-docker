-- config.moon
config = require "lapis.config"

config "development", ->
  port 8080
  num_workers 1
  code_cache "off"
  redis_port 6379

config "production", ->
  port 80
  num_workers 4
  code_cache "on"
  redis_port 6379
