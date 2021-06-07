#! /bin/bash
#
# ~/.bash_profile
#
[[ -f ~/.bash/env.bash ]] && source .bash/env.bash
[[ -f ~/.bashrc ]] && source .bashrc

# Start SSH AGENT
if [ -z "$SSH_AUTH_SOCK" ]
then
   # Check for a currently running instance of the agent
   RUNNING_AGENT="$(pgrep -c ssh-agent | tr -d '[:space:]')"
   if [ "$RUNNING_AGENT" = "0" ]
   then
      # Launch a new instance of the agent
      ssh-agent -s &> .ssh/ssh-agent
   fi
   eval "$(cat .ssh/ssh-agent)"
fi
