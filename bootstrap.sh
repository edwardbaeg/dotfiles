#!/bin/bash
# TODO: replace with stow

# Get the dir of this file (NOT necessarily the current working dir)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Symlinks files or folders
#  $1 source path (eg `./vim/init.lua`)
#  $2 destination path (eg `~/.config/nvim/init.lua`)
#  $3 app name (eg vim) - optional
#  returns 0
# TODO: move existing to archive folder with date subfolders
function symlink_file_or_folder () {
    SOURCE_PATH=$1
    DESTINATION_PATH=$2
    APP_NAME=$3

    # TODO: modify the path string
    if [[ $SOURCE_PATH == */ ]]; then
        echo "paths should not end with /"
        return 0
    fi

    # Check if file/folder "exists" and create a backup
    if test -f "$DESTINATION_PATH"; then
        echo "$3 already exists, creating backup"
        cp $DESTINATION_PATH $DESTINATION_PATH.backup
    fi
    if test -d "$DESTINATION_PATH"; then
        echo "$3 already exists, creating backup"
        cp -r $DESTINATION_PATH "$DESTINATION_PATH"_backup
    fi

    # Check if link exists and remove it
    if test -L "$DESTINATION_PATH"; then
        unlink $DESTINATION_PATH
    fi

    # Remove file/folder if exists
    rm -rf $DESTINATION_PATH

    DESTINATION_PARENT_PATH=$(dirname $DESTINATION_PATH)
    mkdir -p $DESTINATION_PARENT_PATH
    ln -s $SOURCE_PATH $DESTINATION_PATH

    echo "Symlinked $APP_NAME"
    return 0
}

symlink_file_or_folder \
    $DIR/yazi \
    $HOME/.config/yazi \
    yazi

# symlink_file_or_folder \
#     $DIR/nvim \
#     $HOME/.config/nvim \
#     nvim

# symlink_file_or_folder \
#     $DIR/hammerspoon \
#     $HOME/.hammerspoon \
#     Hammerspoon

symlink_file_or_folder \
    "$DIR/neofetch/config.conf" \
    "$HOME/.config/neofetch/config.conf" \
    neofetch

symlink_file_or_folder \
    $DIR/mpv \
    $HOME/.config/mpv \
    mpv

symlink_file_or_folder \
    $DIR/ranger \
    $HOME/.config/ranger \
    ranger

# symlink_file_or_folder \
#     $DIR/.p10k.zsh \
#     $HOME/.p10k.zsh \
#     powerlevel10k.zsh

# symlink_file_or_folder \
#     $DIR/.zshrc \
#     $HOME/.zshrc \
#     zsh

symlink_file_or_folder \
    $DIR/.gitconfig \
    $HOME/.gitconfig \
    git

# symlink_file_or_folder \
#     $DIR/.tmux.conf \
#     $HOME/.tmux.conf \
#     tmux
#
symlink_file_or_folder \
    $DIR/stylua.toml \
    $HOME/stylua.toml \
    stylua

symlink_file_or_folder \
    $DIR/lazygit/config.yml \
    $HOME/.config/lazygit/config.yml \
    lazygit

# symlink_file_or_folder \
#     $DIR/.wezterm.lua \
#     $HOME/.wezterm.lua \
#     wezterm

symlink_file_or_folder \
    $DIR/zellij/config.kdl \
    $HOME/.config/zellij/config.kdl \
    zellij
