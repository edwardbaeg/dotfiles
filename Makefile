all: stow-nvim stow-tmux stow-zsh

stow-nvim:
	stow --verbose --restow -t ~ nvim

stow-tmux:
	stow --verbose --restow -t ~ tmux

stow-zsh:
	stow --verbose --restow -t ~ zsh
