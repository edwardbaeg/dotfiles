#TODO
# add marksman.toml

.PHONY: all clean test stow-nvim stow-tmux stow-zsh stow-hammerspoon stow-wezterm stow-git stow-gh-dash stow-kitty stow-borders stow-bin

all: stow-nvim stow-nvim-lazyvim stow-tmux stow-zsh stow-hammerspoon stow-wezterm stow-git stow-gh-dash stow-kitty stow-borders stow-bin

# TODO: follow a single pattern for directories. Probably set nested dirs here instead of in git filesystem
stow-nvim:
	mkdir -p ~/.config/nvim
	stow --verbose --restow -t ~/.config/nvim nvim

stow-nvim-lazyvim:
	mkdir -p ~/.config/nvim-lazyvim
	stow --verbose --restow -t ~/.config/nvim-lazyvim nvim-lazyvim

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

stow-gh-dash:
	stow --verbose --restow -t ~ gh-dash

stow-kitty:
	stow --verbose --restow -t ~ kitty

stow-borders:
	stow --verbose --restow -t ~ borders

stow-bin:
	stow --verbose --restow -t ~/bin bin

test:
	@echo "No tests defined."
