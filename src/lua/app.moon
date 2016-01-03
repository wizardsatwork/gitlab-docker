-- app.moon
lapis = require "lapis"
moon = require "moon"

class extends lapis.Application
  [index: "/"]: =>
    render: true
