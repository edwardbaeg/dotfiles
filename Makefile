#TODO
# add marksman.toml

.PHONY: all clean test stow-nvim stow-tmux stow-zsh stow-hammerspoon stow-wezterm stow-git stow-gh-dash stow-kitty stow-borders stow-bin

all: stow-nvim stow-nvim-lazyvim stow-tmux stow-zsh stow-hammerspoon stow-wezterm stow-git stow-gh-dash stow-kitty stow-borders stow-bin

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
	mkdir -p ~/.hammerspoon
	stow --verbose --restow -t ~/.hammerspoon hammerspoon

stow-wezterm:
	stow --verbose --restow -t ~ wezterm

stow-git:
	stow --verbose --restow -t ~ gitconfig

stow-gh-dash:
	stow --verbose --restow -t ~ gh-dash

stow-kitty:
	mkdir -p ~/.config/kitty
	stow --verbose --restow -t ~/.config/kitty kitty

stow-borders:
	mkdir -p ~/.config/borders
	stow --verbose --restow -t ~/.config/borders borders

stow-bin:
	stow --verbose --restow -t ~/bin bin

stow-claude:
	stow --verbose --restow -t ~/.claude claude

test:
	@echo "No tests defined."
