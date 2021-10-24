#! /bin/bash
#

[[ -f "$HOME"/.bashrc ]] && source "$HOME"/.bashrc
[[ -f "$HOME"/.bash/env.bash ]] && source "$HOME"/.bash/env.bash

# load anyenv config
_checkexec anyenv && eval "$(anyenv init -)"
