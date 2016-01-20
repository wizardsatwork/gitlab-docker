package.path = '/usr/share/lua/5.1/lapis/?.lua;' .. package.path
lapis = require "lapis"

class extends lapis.Application
  layout: require "views.layout"

  [index: "/"]: =>
    render: true
