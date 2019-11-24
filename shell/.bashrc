#
# ~/.bashrc
#

# Description
# ===========
#
# BASH configuration file.  Any modules such as the `dircolors` config
# are stored in ~/.local/share/my_bash/.  This setup is part of my
# dotfiles.  See https://gitlab.com/protesilaos/dotfiles.
#
# Note that ALL MY SCRIPTS are designed to work with `#!/bin/bash`.
# They are not tested for portability.
#
# Last full review on 2019-06-28

# Shorter version of a common command that it used herein.
_checkexec() {
	command -v "$1" > /dev/null
}

# General settings
# ================

# Default pager.  Note that the option I pass to it will quit once you
# try to scroll past the end of the file.
export PAGER="less --quit-at-eof"
export MANPAGER=$PAGER

# Simple prompt
if [ -n "$SSH_CONNECTION" ]; then
	export PS1="\u@\h: \w \$ "
else
	export PS1="\w \$ "
fi
export PS2="> "

# The following is taken from the .bashrc shipped with Debian 9.  Enable
# programmable completion features (you don't need to enable this, if
# it's already enabled in /etc/bash.bashrc and /etc/profile sources
# /etc/bash.bashrc).
if ! shopt -oq posix; then
	[ -f ~/.bash/bash-completion.bash ] && . ~/.bash/bash-completion.bash 
fi

if [ "$(command -v fzf 2> /dev/null)" ]; then
	[ -f ~/.bash/key-bindings.bash ] && . ~/.bash/key-bindings.bash
	[ -f ~/.bash/fzf-completion.bash ] && bash ~/.bash/fzf-completion.bash

	# Load plugins
	for plugin in $(ls -d ~/.bash/fzf-plugins/*)
	do
		source $plugin
	done
fi

# Enable tab completion when starting a command with 'sudo'
[ "$PS1" ] && complete -cf sudo

# If not running interactively, don't do anything.  This too is taken
# from Debian 9's bashrc.
case $- in
	*i*) ;;
	  *) return;;
esac

# Don't put duplicate lines or lines starting with space in the history.
# See `man bash` for more options.
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it.
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in `man bash`.
HISTSIZE=1000
HISTFILESIZE=2000

# Check the window size after each command and, if necessary, update the
# values of LINES and COLUMNS.
shopt -s checkwinsize

# Make `less` more friendly for non-text input files.
_checkexec lesspipe && eval "$(SHELL=/bin/sh lesspipe)"

# Load aliases
[ -f ~/.bash/aliases.bash ] && . ~/.bash/aliases.bash

# Load functions
[ -f ~/.bash/funcs.bash ] && . ~/.bash/funcs.bash

# Use prompt startship
_checkexec starship && eval "$(starship init bash)"
