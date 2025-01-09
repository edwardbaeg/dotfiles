all: stow-nvim stow-tmux stow-zsh stow-hammerspoon stow-wezterm stow-git

stow-nvim:
	stow --verbose --restow -t ~ nvim

stow-tmux:
	stow --verbose --restow -t ~ tmux

stow-zsh:
	stow --verbose --restow -t ~ zsh

stow-hammerspoon:
	stow --verbose --restow -t ~ hammerspoon

stow-wezterm:
	stow --verbose --restow -t ~ wezterm

stow-git:
	stow --verbose --restow -t ~ gitconfig
