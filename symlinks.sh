#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

HAMMERSPOON_PATH="$HOME/.hammerspoon/init.lua"
if test -f "$HAMMERSPOON_PATH"; then
  # remove link
  unlink $HAMMERSPOON_PATH

  # create a backup
  echo "hammerspoon file exists, creating backup"
  mv $HAMMERSPOON_PATH $HAMMERSPOON_PATH.backup
fi

ln -s $DIR/init.lua $HAMMERSPOON_PATH
echo "symlinked hammerspoon"
