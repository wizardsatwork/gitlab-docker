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
  for module in "${$SUB_MODULES[@]}"
  do
    cd $module && \
    git fetch && \
    git merge origin/master
  done
}

function crontab () {
  CRONTAB_FILE=$PWD/crontab.txt

  echo "creating crontab.txt"

  rm -f $CRONTAB_FILE

  echo "23 05 * * * \"cd ${PWD} && make backup\" > /dev/null" >> $CRONTAB_FILE

  echo "writing to crontab"
  crontab $CRONTAB_FILE

  echo "crontab setup done"
}

function all() {
  init_submodules
  crontab
}

if [ $1 ]
then
  function=$1
  shift
  $function $@
else
  help $@
fi

