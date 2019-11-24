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
if [ -d "$HOME/bin" ] ; then
    appendpath "$HOME/bin"
fi

# Default editor.  On Debian the Vim GUI is provided by a separate
# package.
if _checkexec code; then
	export VISUAL="code"
	export EDITOR=vim
else
	export VISUAL=vim
	export EDITOR=$VISUAL
fi

# Default browser.  This leverages the MIME list.
export BROWSER=/usr/bin/xdg-open

# Directory of pass store
export PASSWORD_STORE_DIR="/media/Data/Documents/workspace/sypass"

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

# npm
export NPM_HOME="$HOME/.npm-global"

# gpg
export GNUPGHOME="~/.gnupg/"
