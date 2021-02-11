# Append our default paths
appendpath () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}

# Shorter version of a common command that it used herein.
_checkexec() {
    command -v "$1" > /dev/null
}

# Include my scripts in the PATH.  To avoid conflicts, I always prepend
# `own_script_` to my files.  There are some exceptions though, where I
# am confident that no conflicts will arrise.  See the 'bin' directory
# of my dotfiles.
[ -d "$HOME/bin" ] && appendpath "$HOME/bin"

# Add pip user packages to PATH
[ -d "$HOME/.local/bin" ] && appendpath "$HOME/.local/bin"

# Default editor.  On Debian the Vim GUI is provided by a separate
# package.
export EDITOR=nvim

export BROWSER=/usr/bin/xdg-open

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

# go
export GOPATH="$HOME/go"

# pipenv
export PIPENV_VENV_IN_PROJECT=1

# folder to store globally packages
#export NPM_HOME="$HOME/.npm-global"
#[ -d "$NPM_HOME/bin" ] && appendpath "$NPM_HOME/bin"

# gpg
export GNUPGHOME="~/.gnupg/"

# Python env
#export WORKON_HOME=$HOME/.virtualenvs   # Optional