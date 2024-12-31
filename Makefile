all: stow-nvim stow-tmux

stow-nvim:
	stow --verbose --restow -t ~ nvim

stow-tmux:
	stow --verbose --restow -t ~ tmux
