#! /bin/bash
#

[[ -f "$HOME"/.bashrc ]] && source "$HOME"/.bashrc
[[ -f "$HOME"/.bash/env.bash ]] && source "$HOME"/.bash/env.bash

# load anyenv config
_checkexec anyenv && eval "$(anyenv init -)"
eval "$($HOME/.local/bin/mise activate bash --shims)"

if [ -z "$SSH_AUTH_SOCK" ]
then
   RUNNING_AGENT="$(pgrep -c ssh-agent | tr -d '[:space:]')"
   if [ "$RUNNING_AGENT" = "0" ]
   then
      [[ -S "$HOME"/.ssh-agent.sock ]] && \rm "$HOME"/.ssh-agent.sock
      ssh-agent -a "$HOME"/.ssh-agent.sock -s &> "$HOME"/.ssh/ssh-agent
   fi
   eval "$(cat "$HOME"/.ssh/ssh-agent)"
fi

# _checkexec nmcli && nmcli con up static-home &
