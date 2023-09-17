#! /bin/bash

# add anyenv to path
prependpath "$HOME/.anyenv/bin"

prependpath "$HOME/.cargo/bin"

# Include my scripts in the PATH.  To avoid conflicts, I always prepend
# `own_script_` to my files.  There are some exceptions though, where I
# am confident that no conflicts will arrise.  See the 'bin' directory
# of my dotfiles.
[ -d "$HOME/bin" ] && appendpath "$HOME/bin"

# Add pip user packages to PATH
[ -d "$HOME/.local/bin" ] && appendpath "$HOME/.local/bin"

# load lua paths
_checkexec luarocks && {
  test ! "$(echo "$PATH" | grep -w ~/.luarocks/bin)" && eval "$(luarocks path)"
}

# Default editor.  On Debian the Vim GUI is provided by a separate
# package.
export EDITOR=nvim

# export BROWSER=/usr/bin/xdg-open

# Pass config
export PASSWORD_STORE_DIR="/home/ernest/workspace/sypass"
export PASSWORD_STORE_ENABLE_EXTENSIONS=true

# XDG Paths
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_DIRS="/etc/xdg"

# Java
export JAVA_HOME="/usr/lib/jvm/default"
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.xrender=true"

# go
export GOPATH="$HOME/go"

# pipenv
export PIPENV_VENV_IN_PROJECT=1

# gpg
export GNUPGHOME="$HOME/.gnupg/"

# enable docker build kit
export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1

export ROFI_THEME="gruvbox-dark-soft"

export DOTNET_CLI_TELEMETRY_OPTOUT=1