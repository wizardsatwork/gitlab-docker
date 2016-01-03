import Widget from require "lapis.html"

import u from require "utils"

class Layout extends Widget
  content: =>
    html_5 ->
      head ->
        meta charset: "utf-8"
        title @title or "Magic!"

        link
          rel: "icon"
          href: u.cdn_host "/favicon.ico"

        meta
          name: "description"
          content: "Magic."

      body id: "♥", ->
        @content_for "inner"
