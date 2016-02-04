#!/bin/bash

CRONTAB_FILE=$PWD/crontab.txt

echo "creating crontab.txt"

rm -f $CRONTAB_FILE

echo "23 05 * * * \"cd ${PWD} && make backup\" > /dev/null" >> $CRONTAB_FILE

echo "writing to crontab"
crontab $CRONTAB_FILE

echo "crontab setup done"
