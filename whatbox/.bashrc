# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.
# Enables ^s and ^q in rTorrent, when running in screen
stty -ixon -ixoff
# PATH=$HOME/bin:$PATH
# export PATH="$PATH:/home/$USER/bin:"
# PATH=$HOME/bin:$PATH
# export PATH=$PATH:$HOME/bin/ranger
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/bin/nvim-linux64/bin
export PATH=$PATH:$HOME/bin/ranger/ranger.py

alias v=vim
alias vb='vim ~/.bashrc'
alias sb='source ~/.bashrc'
# alias ranger='~/bin/ranger/ranger.py'
# alias ra='~/bin/ranger/ranger.py'
alias ..='cd ..'
