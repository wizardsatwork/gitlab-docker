module "u", package.seeall
export cdn_host

cdn_host = (file) ->
  host_id = math.floor math.random! * 9 + 1

  "http://s#{host_id}.localhost:8080/#{file}"
