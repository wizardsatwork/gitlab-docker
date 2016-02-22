#!/bin/bash

SUB_MODULES=( redis postgres mongodb gitlab redmine rocketchat )

function add_submodules() {
  echo "adding submodules remotes"

  for module in "${SUB_MODULES[@]}"
  do
    echo "adding submodule: $module"
    git submodule add https://github.com/grundstein/$module.git
    git commit -am 'add submodule: $module'
    echo "finished submodule: $module"
  done
  echo "submodules added"
}

function init_submodules() {

  echo "init submodules"
  git submodule init
  echo "init submodules finished"
}

function update_submodules() {

  echo "update submodules"

  #!/bin/bash
  for module in "${SUB_MODULES[@]}"
  do
    cd $PWD/$module && \
    git fetch && \
    git merge origin/master && \
    cd ..
  done
}

function all() {
  init_submodules
}

if [ $1 ]
then
  function=$1
  shift
  $function $@
else
  help $@
fi

