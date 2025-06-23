#!/bin/bash

# Split the window vertically
tmux split-window -h

# Split the new pane vertically again
tmux split-window -h

# Set the layout to even-horizontal
tmux select-layout even-horizontal

# Focus the middle pane
tmux select-pane -L
