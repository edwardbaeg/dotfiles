.PHONY: all clean test stow-nvim stow-tmux stow-zsh stow-hammerspoon stow-wezterm stow-git stow-gh-dash stow-kitty stow-borders stow-bin

all: stow-nvim stow-tmux stow-zsh stow-hammerspoon stow-wezterm stow-git stow-gh-dash stow-kitty stow-borders stow-bin

# TODO: follow a single pattern for directories. Probably set nested dirs here instead of in git filesystem
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

stow-gh-dash:
	stow --verbose --restow -t ~ gh-dash

stow-kitty:
	stow --verbose --restow -t ~ kitty

stow-borders:
	stow --verbose --restow -t ~ borders

stow-bin:
	stow --verbose --restow -t ~/bin bin

clean:
	stow --delete -t ~ nvim tmux zsh hammerspoon wezterm gitconfig gh-dash kitty borders bin

test:
	@echo "No tests defined."
