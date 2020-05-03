#!/bin/bash

# Get the dir of this file (NOT necessarily the current working dir)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

HAMMERSPOON_PATH="$HOME/.hammerspoon/init.lua"
if test -L "$HAMMERSPOON_PATH"; then
  # remove link
  unlink $HAMMERSPOON_PATH
elif test -f "$INITVIM_PATH"; then
  # delete and create a backup
  echo "hammerspoon file exists, creating backup"
  mv $HAMMERSPOON_PATH $HAMMERSPOON_PATH.backup
fi

mkdir -p $HOME/.hammerspoon
ln -s $DIR/hammerspoon/init.lua $HAMMERSPOON_PATH
echo "symlinked hammerspoon"

INITVIM_PATH="$HOME/.config/nvim/init.vim"
# Checks if symbolic link (but file may not exist)
if test -L "$INITVIM_PATH"; then
  # Remove link first
  unlink $INITVIM_PATH
# Checks if file exists
elif test -f "$INITVIM_PATH"; then
  # delete and create a backup
  echo "init.vim file exists, creating backup"
  mv $INITVIM_PATH $INITVIM_PATH.backup
fi

mkdir -p $HOME/.config/nvim/
ln -s $DIR/vim/init.vim $INITVIM_PATH
echo "symlinked init.vim"
