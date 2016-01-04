-- config.moon
config = require "lapis.config"

config {"production", "development"}, ->
  port: 80
  num_workers: 4
  code_cache: "on"
  secret: "please-change-me"
  session_name: "lapis_session"
  logging:
    queries: true
    requests: true

config "development", ->
  port: 8080
