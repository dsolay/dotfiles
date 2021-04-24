#!/bin/bash

# Shorter version of a common command that it used herein.
_checkexec() {
	command -v "$1" > /dev/null
}

# Aliases
# =======
# A note on how I define aliases.  I try to abstract the command into
# its initials or something that resembles the original.  This helps me
# remember the original command when necessary.  There are some
# exceptions for commands I seldom execute.

# APT (package management on Debian)
# ----------------------------------

# If you are coming to Debian from Arch-based distros, check
# compatibility with `pacman`:
# https://wiki.archlinux.org/index.php/Pacman/Rosetta
if _checkexec apt; then
	# up{dating,grading}.  The -V shows version changes.
	alias au="sudo apt update"
	alias aug="sudo apt upgrade -V"
	alias auu="sudo apt update && sudo apt upgrade -V"
	alias afu="sudo apt full-upgrade -V"
	alias auufu="sudo apt update && sudo apt upgrade -V && sudo apt full-upgrade -V"

	# act on package targets
	alias ai="sudo apt install"
	alias air="sudo apt install --reinstall"
	alias ar="sudo apt remove -V"

	# list local packages
	alias ard="apt rdepends" # followed by package name to print reverse dependencies
	alias ali="apt list --installed"
	alias alu="apt list --upgradable"
	alias aulu="sudo apt update && apt list --upgradable"

	# act on the repos
	alias as="apt search"
	alias ash="apt show"
	alias adl="apt download" # gets source .deb in current directory

	# package handling
	alias aac="sudo apt autoclean"
	alias aar="sudo apt autoremove -V"
	alias ama="sudo apt-mark auto"
	alias amm="sudo apt-mark manual"
fi

# No point in checking for dpkg on a Debian system.  Still, it can help
# people who copy-paste stuff.
if _checkexec dpkg; then
	alias dgl='dpkg --listfiles' # target a package name, e.g. dgl bspwm
	alias dgg='dpkg --get-selections' # would normally be pipped to grep
	# The following removes/purges unused configs without asking for
	# confirmation.  Same end product as 'alias apc' (see below where
	# aptitude is defined).
	alias dgp='sudo dpkg --purge $(dpkg --get-selections | grep deinstall | cut -f 1)'
fi

if _checkexec aptitude; then
	# The following two aliases perform the same action of removing
	# unused system files.  Unlike 'alias dgp', confirmation is needed.
	#alias apc="sudo aptitude purge ?config-files"
	alias apc="sudo aptitude purge ~c"
fi

# PACMAN (package management on Arch)
# ----------------------------------

if _checkexec pacman; then
	# up{dating,grading}.  The -V shows version changes.
	alias pup='sudo pacman -Syuu' # update
	alias afu="sudo apt full-upgrade -V"
	alias auufu="sudo apt update && sudo apt upgrade -V && sudo apt full-upgrade -V"

	# act on package targets
	alias pin="sudo pacman -S"
	alias pinu="sudo pacman -U"
	alias pun='sudo pacman -Rs'   # remove
	alias prm='sudo pacman -R --nosave --recursive' # really remove, configs and all

	# list local packages
	alias pls='pacman -Ql' # list files
	alias plsi='pacman -Qe' # list instaled package

	# act on the repos
	# alias psse="sudo pacman -Ss"

	# package handling
	alias pcc='sudo pacman -Scc'  # clear cache
fi

if _checkexec docker; then
	alias dp='docker pull'
	alias dps='docker ps'
	alias dpsa='docker ps -a'
	alias dimg='docker images'
	alias dit='docker run -it --rm'
	alias ditx='docker run -it --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix'
	alias deit='docker exec -it'
	alias ds='docker start'
	alias drm='docker rm -f $(docker ps -aq)'
	alias drmi='docker rmi'
	alias db='docker build -t'
	alias dlog='docker logs'

	if _checkexec docker-compose; then
		alias dc='docker-compose'
		alias dcb='docker-compose build'
		alias dcps='docker-compose ps'
		alias dcup='docker-compose up -d'
		alias dcrm='docker-compose rm'
		alias dcst='docker-compose stop'
		alias dcexc='docker-compose exec'
		alias dclog='docker-compose logs'
	fi
fi

# Common tasks and utilities
# --------------------------

# Check these because some of them modify the behaviour of standard
# commands, such as `cp`, `mv`, `rm`, so that they provide verbose
# output and open a prompt when an existing file is affected.
#
# PRO TIP to ignore aliases, start them with a backslash \.  The
# original command will be used.  This is useful when the original
# command and the alias have the same name.  Example is my `cp` which is
# aliased to `cp -iv`:
#
#	cp == cp -iv
#	\cp == cp

# Build pkg
alias pkg='makepkg --printsrcinfo > .SRCINFO && makepkg -fsrc'
alias spkg='pkg --sign'

# Build
alias mk='make && make clean'
alias smk='sudo make clean install && make clean'
alias ssmk='sudo make clean install && make clean && rm -iv config.h'

# network
alias plisten='ss -lptn'

# Disk space
alias du='du -hs'
alias duh='du -hs .[^.]*'
alias df='df -kTh'

# Aliases inside tmux session
if [[ $TERM == *tmux* ]]; then
	alias :sp='tmux split-window'
	alias :vs='tmux split-window -h'
fi
alias rtmux='tmux source-file ~/.tmux.conf'
alias tkw='tmux kill-window -t'
alias tks='tmux kill-session -t'
alias tmew='tmux new'

# Update mirror list
if _checkexec reflector; then
	alias mir='sudo reflector --score 100 -l 50 -f 10 --sort rate --save /etc/pacman.d/mirrorlist --verbose'
fi

# Record Screen
if _checkexec byzanz-record; then
	alias gif='byzanz-record -x 1090 -w 750 -y 430 -h 480 -v -d 15 ~/Videos/$(date +%a-%d-%S).gif'
fi

alias rec='ffmpeg -video_size 1920x1080 -framerate 60 -f x11grab -i :0.0 -c:v libx264 -qp 0 -preset ultrafast ~/Videos/$(date +%a-%d-%S).mkv'

if _checkexec python; then
	alias calc='python -qi -c "from math import *"'
fi

alias brok='sudo find . -type l -! -exec test -e {} \; -print'
alias timer='time read -p "Press enter to stop"'

# shellcheck disable=2142
alias xp='xprop | awk -F\"'" '/CLASS/ {printf \"NAME = %s\nCLASS = %s\n\", \$2, \$4}'"
alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'

# services
alias restart='sudo systemctl restart'
alias start='sudo systemctl start'
alias stop='sudo systemctl stop'
alias status='sudo systemctl status'
alias disable='sudo systemctl disable'
alias enable='sudo systemctl enable'

# System
alias logout='pkill -KILL -U'
alias off='sudo shutdown -h now'

# _Entering_ Vim is easy.
if _checkexec vim; then
	alias v='vim'
	alias vi='vim'
fi

# cd into the previous working directory by omitting `cd`.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mkdir='mkdir -pv'
alias debug="set -o nounset; set -o xtrace"

# Safer default for cp, mv, rm.  These will print a verbose output of
# the operations.  If an existing file is affected, they will ask for
# confirmation.  This can make things a bit more cumbersome, but is a
# generally safer option.
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'

# Some common tasks for the `rsync` utiity.
if _checkexec rsync; then
	alias rsync='rsync --progress'
	alias rsyncavz='rsync -avz --progress'
	alias rsyncavzr='rsync -avzr --progress'
	alias rsyncavzrd='rsync -avzr --delete --progress'
fi

# Enable automatic color support for common commands that list output
# and also add handy aliases.  Note the link to the `dircolors`.  This
# is provided by my dotfiles.
if _checkexec dircolors; then
	dircolors_data="$HOME/.local/share/my_bash/dircolors"
	test -r $dircolors_data && eval "$(dircolors -b ${dircolors_data})" || eval "$(dircolors -b)"
fi

alias diff='diff --color=auto'

alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Make ls a bit easier to read.  Note that the -A is the same as -a but
# does not include implied paths (the current dir denoted by a dot and
# the previous dir denoted by two dots).  I would also like to use the
# -p option, which prepends a forward slash to directories, but it does
# not seem to work with symlinked directories. For more, see `man ls`.
alias ls='ls -pv --color=auto --group-directories-first'
alias lsa='ls -pvA --color=auto --group-directories-first'
alias lsl='ls -lhpv --color=auto --group-directories-first'
alias lsla='ls -lhpvA --color=auto --group-directories-first'

# Extra tasks and infrequently used tools
# ---------------------------------------

# These options are very opinionated, disabling images, javascript,
# etc.  See `man surf`.
if _checkexec surf; then
	alias surf="surf -giKMnps"
fi

# Quick shortcuts for `mpv`.  When I want to play a podcast that only
# shows a static image, I run the command with the --no-video option.
# When I only need to view the file I use --no-audio.  The one with
# --ytdl-raw-options is for those occasions where a video is 4k or
# something that slows things down considerably.
if _checkexec mpv; then
	alias mpvna='mpv --no-audio'
	alias mpvnv='mpv --no-video'
	alias mpvhd="mpv --ytdl-raw-options='format=[[bestvideo=height<=720]]'"
fi

# Quick shortcuts for `youtube-dl`.  Output is placed in the present
# working directory.
if _checkexec youtube-dl; then
	alias ytaud='youtube-dl --add-metadata -ci --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s"'
	alias ytvid='youtube-dl --add-metadata --no-playlist --no-part --write-description --newline --prefer-free-formats -o "%(title)s.%(ext)s" '
fi

# Certbot.  This is a utility that handles Let's Encrypt certificates
# for https connections.
if _checkexec certbot; then
	alias certm='sudo certbot certonly -a manual -d'
fi

# When I need to copy the contents of a file to the clipboard
if _checkexec xclip; then
	alias xclipc='xclip -selection clipboard' # followed by path to file
	alias copy='xclip -sel clip <'
fi

# Flatpak commands
# ----------------

if _checkexec flatpak; then
	alias fli="flatpak install" # must be followed by a source, e.g. fli flathub
	alias fliu="flatpak uninstall"
	alias flls="flatpak list --app --columns='desc,app,orig'"
	alias flu="flatpak update"
fi

# Git commands
# ------------

if _checkexec git; then
	# add, commit
	alias gadd='git add -v'
	alias gaddp='git add --patch'
	alias gaddi='git add --interactive'
	alias gall='git add -Av'
	alias gcom='git commit' # opens in the predefined editor.
	alias gcomm='git commit -m' # pass a message directly: gcomm 'My commit'
	alias gca='git commit --amend'
	alias grh='git reset HEAD'

	# stats and diffs
	alias gsh='git show'
	alias gsho='git show --oneline'
	alias glog='git log --oneline'
	alias gsta='git status'
	alias gstat='git status'
	alias gdif='git diff'
	alias gdiff='git diff'
	alias gdifs='git diff --stat --summary'
	alias gdiffss='git diff --stat --summary'

	# branching
	alias gch='git checkout'
	alias gchb='git checkout -b'
	alias gbd='git branch -d'
	alias gbl='git branch --list'
	alias gpd='git push origin --delete'
	alias gmerg='git merge --edit --stat'
	alias gmerge='git merge --edit --stat'

	# tagging
	alias gtag='git tag --sign' # followed by the tag's name
	alias gtagl='git tag --list'

	# syncing
	alias gpull='git pull'
	alias gfetch='git fetch'
	alias gpm='git push -u origin master'
	alias gph='git push -u origin HEAD'

	alias glNoGraph='git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr% C(auto)%an" "$@"'
	_gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
	_checkexec diff-so-fancy && _viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy'"
fi

# Open current directory in nvim
alias ide="nvim ."

# Update fonts
alias fup="fc-cache -vf"

# Print PATH in human readable
alias path='echo $PATH | tr ":" "\n" | nl'

# Emoji
alias lod='echo "ಠ_ಠ"'
alias idk='echo "¯\_(ツ)_/¯"'
alias wtf='echo "❨╯°□°❩╯ ︵ ┻━┻"'
alias wat='echo "⚆_⚆"'