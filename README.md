# wizardsatwork/gitlaboratory

runs a dockerized gitlab instance

#### Usage:
```bash
  # run docker container
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

#### Todo:
replace port 2222 with 22 for machine that has no ssh installed natively once we set that machine up.
