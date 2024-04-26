#!/bin/bash

# git reset HEAD --hard
#git pull
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
find "$SCRIPT_DIR"/bin -type f -exec chmod u+x {} \;
SC='/usr/local/sc'
cp -Rv "$SCRIPT_DIR"/* "$SC"
