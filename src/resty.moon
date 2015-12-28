-- app.moon
lapis = require "lapis"
moon = require "moon"

class extends lapis.Application
  "/": =>
    moon.p {route: "/", description: "loading root route"}
    "Welcome to Magic #{require "lapis.version"}! "

