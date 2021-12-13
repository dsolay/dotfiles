#! /bin/bash
#

[[ -f "$HOME"/.bashrc ]] && source "$HOME"/.bashrc
[[ -f "$HOME"/.bash/env.bash ]] && source "$HOME"/.bash/env.bash

# load anyenv config
_checkexec anyenv && eval "$(anyenv init -)"

# Start SSH AGENT
if [ -z "$SSH_AUTH_SOCK" ]
then
   # Check for a currently running instance of the agent
   RUNNING_AGENT="$(pgrep -c ssh-agent | tr -d '[:space:]')"
   if [ "$RUNNING_AGENT" = "0" ]
   then
      # Launch a new instance of the agent
      ssh-agent -a "$HOME"/.ssh-agent.sock -s &> "$HOME"/.ssh/ssh-agent
   fi
   eval "$(cat "$HOME"/.ssh/ssh-agent)"
fi
