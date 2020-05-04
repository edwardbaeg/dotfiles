#!/bin/bash

# Get the dir of this file (NOT necessarily the current working dir)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

HAMMERSPOON_PATH="$HOME/.hammerspoon/init.lua"
if test -f "$HAMMERSPOON_PATH"; then
  # create a backup
  echo "hammerspoon file exists, creating backup"
  cp $HAMMERSPOON_PATH $HAMMERSPOON_PATH.backup
fi
if test -L "$HAMMERSPOON_PATH"; then
  # remove link
  unlink $HAMMERSPOON_PATH
fi

# Use -f to avoid error
rm -f $HAMMERSPOON_PATH

mkdir -p $HOME/.hammerspoon
ln -s $DIR/hammerspoon/init.lua $HAMMERSPOON_PATH
echo "symlinked hammerspoon"

# INITVIM_PATH="$HOME/.config/nvim/init.vim"
# # Checks if symbolic link (but file may not exist)
# if test -L "$INITVIM_PATH"; then
#   # Remove link first
#   unlink $INITVIM_PATH
# # Checks if file exists
# fi
# if test -f "$INITVIM_PATH"; then
#   # delete and create a backup
#   echo "init.vim file exists, creating backup"
#   mv $INITVIM_PATH $INITVIM_PATH.backup
# fi

# mkdir -p $HOME/.config/nvim/
# ln -s $DIR/vim/init.vim $INITVIM_PATH
# echo "symlinked init.vim"

# # DIRECTORIES

# MPV_PATH="$HOME/.config/mpv"
# # Checks if symbolic link (but file may not exist)
# if test -L "$MPV_PATH"; then
#   # Remove link first
#   unlink $MPV_PATH
# # Checks if file exists
# fi
# if test -d "$MPV_PATH"; then
#   # delete and create a backup
#   echo "mpv directory exists, creating backup"
#   mv $MPV_PATH $MPV_PATH.backup
# fi
# ln -s $DIR/mpv/ $MPV_PATH
# echo "symlinked mpv"

# RANGER_PATH="$HOME/.config/ranger"
# if test -L "$RANGER_PATH"; then
#   # Remove link first
#   unlink $RANGER_PATH
# # Checks if file exists
# fi
# if test -d "$RANGER_PATH"; then
#   # delete and create a backup
#   echo "ranger directory exists, creating backup"
#   mv $RANGER_PATH $RANGER_PATH.backup
# fi
# ln -s $DIR/ranger/ $RANGER_PATH
# echo "symlinked ranger"
