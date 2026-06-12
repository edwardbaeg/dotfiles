# Tmux

## Resources

- The Tao Of Tmux: great overall resource - https://leanpub.com/the-tao-of-tmux/read
- protip: run `:Man tmux` in nvim split

## Keybinding, command reference

- Copy (scroll) mode: `<prefix> [`, or `<prefix> :copy-mode`, or `<prefix> v` (custom)
- Undo layout change: `<prefix> :select-layout -o`
- Pane jump mode: `<prefix> q`
- Tree mode
  - Session tree mode: `<prefix> s`, `:choose-tree -s`, or `alt/cmd+s` (custom)
  - Window tree mode: `:choose-tree -w` or `alt/cmd+d` (custom)
  - can do `:` to run a command for the selected node
- Move window to different session: `<prefix> .` `[<position> | <session>:<position>]`
- Rename current window: `<prefix> ,`
- Rename current session: `<prefix> $`
- Go to last window: `<prefix> L` (uppercase)

## Misc notes

- On mac, both CMD and OPT correspond to META `M-`
- Formatting: check the FORMATS section of the man page; set with `-F`; conditionals prefixed with `?`

## `tmuxp`

### Overview

tmuxp is a session manager for tmux that allows you to define and load tmux sessions using YAML or JSON configuration files.

### Configuration Reference

Use `man tmux | grep -A 5 -B 5 "option-name"` to search for specific tmux configuration settings and options.

### Notes

- Configuration files are executed as tmux commands when server starts
- Use `tmux source-file ~/.tmux.conf` to reload configuration
- run `tmpuxp load <file>` from within a tmux session to have the option to append to it
