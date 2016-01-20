# wizardsatwork/grundstein

Grundstein (plural Grundsteine) [german]

* A ceremonial stone set at the corner of a building.

* By extension, that which is prominent, fundamental, noteworthy, or central.
Exceptional service is the cornerstone of the hospitality industry.
That is the cornerstone of any meaningful debate about budgets and projects, regulations and policies.

via: [wiktionary](https://en.wiktionary.org/wiki/grundstein)

runs docker instances of the various services we use:
gitlab
redmine
openresty/nginx
postgres
redis
mail

#### Usage:
```bash
  # run docker containers
  make

  #then just:
  xdg-open http://gitlab

  # stop container
  make stop

  # remove container
  make remove

  # update container
  make update

```
