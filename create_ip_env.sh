#!/bin/bash

echo "Start ip gathering for env generation"

GENERATED_CWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

OPENRESTY_FILE=$GENERATED_CWD/openresty/IPS.sh
REDMINE_FILE=$GENERATED_CWD/redmine/IPS.sh

echo "\
#!/bin/bash
$(python ips.py)
" > $OPENRESTY_FILE

echo "wrote $OPENRESTY_FILE"

echo "\
#!/bin/bash
$(python ips.py)
" > $REDMINE_FILE

echo "wrote $REDMINE_FILE"
