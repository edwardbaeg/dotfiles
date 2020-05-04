#!/bin/bash

# Get the dir of this file (NOT necessarily the current working dir)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Symlinks files
#  $1 source path (eg `./vim/init.vim`)
#  $2 destination path (eg `~/.config/nvim/init.vim`)
#  $3 app name (eg vim)
#  returns 0
function symlink_file () {
  SOURCE_PATH=$1
  DESTINATION_PATH=$2
  APP_NAME=$3

  # Check if file "exists" and create a backup
  if test -f "$DESTINATION_PATH"; then
    echo "$3 already exists, creating backup"
    cp $DESTINATION_PATH $DESTINATION_PATH.backup
  fi

  # Check if link exists and remove it
  if test -L "$DESTINATION_PATH"; then
    unlink $DESTINATION_PATH
  fi

  # Remove file if exists
  rm -f $DESTINATION_PATH

  DESTINATION_PARENT_PATH=$(dirname $DESTINATION_PATH)
  mkdir -p $DESTINATION_PARENT_PATH
  ln -s $SOURCE_PATH $DESTINATION_PATH
  echo "Symlinked $APP_NAME"

  return 0
}

symlink_file \
  "$DIR/hammerspoon/init.lua" \
  "$HOME/.hammerspoon/init.lua" \
  Hammerspoon

symlink_file \
  "$DIR/nvim/init.vim" \
  "$HOME/.config/nvim/init.vim" \
  nvim

symlink_file \
  "$DIR/neofetch/config.conf" \
  "$HOME/.config/neofetch/config.conf" \
  neofetch

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
