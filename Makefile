all:
	stow-nvim

stow-nvim:
	stow --verbose --restow -t ~ nvim
