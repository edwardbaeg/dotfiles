# tmuxp Configuration Notes

## Overview
tmuxp is a session manager for tmux that allows you to define and load tmux sessions using YAML or JSON configuration files.

## Configuration Reference
Use `man tmux | grep -A 5 -B 5 "option-name"` to search for specific tmux configuration settings and options.

## Notes
- Configuration files are executed as tmux commands when server starts
- Use `tmux source-file ~/.tmux.conf` to reload configuration