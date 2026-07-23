#! /bin/bash

# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/.local/share/kiro-cli/shell/bash_profile.pre.bash" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/bash_profile.pre.bash"

#

[[ -f "$HOME"/.bashrc ]] && source "$HOME"/.bashrc
[[ -f "$HOME"/.bash/env.bash ]] && source "$HOME"/.bash/env.bash

# load anyenv config
#_checkexec anyenv && eval "$(anyenv init -)"

_checkexec mise && eval "$(mise activate bash --shims)"

export SSH_AUTH_SOCK=~/.1password/agent.sock

# Start SSH AGENT
# if [ -z "$SSH_AUTH_SOCK" ]
# then
#    RUNNING_AGENT="$(pgrep -c ssh-agent | tr -d '[:space:]')"
#    if [ "$RUNNING_AGENT" = "0" ]
#    then
#       [[ -S "$HOME"/.ssh-agent.sock ]] && \rm "$HOME"/.ssh-agent.sock
#       ssh-agent -a "$HOME"/.ssh-agent.sock -s &> "$HOME"/.ssh/ssh-agent
#    fi
#    eval "$(cat "$HOME"/.ssh/ssh-agent)"
# fi

# _checkexec nmcli && nmcli con up static-home &


# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/.local/share/kiro-cli/shell/bash_profile.post.bash" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/bash_profile.post.bash"
# >>> llmtrim >>>
if command -v llmtrim >/dev/null 2>&1 && llmtrim _alive 2>/dev/null; then
    export HTTPS_PROXY='http://127.0.0.1:43117'
    export HTTP_PROXY='http://127.0.0.1:43117'
    export NO_PROXY='localhost,127.0.0.1,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,169.254.0.0/16,fd00::/8,*.local'
    export no_proxy='localhost,127.0.0.1,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,169.254.0.0/16,fd00::/8,*.local'
    export NODE_EXTRA_CA_CERTS='/home/ernest/.llmtrim/ca.pem'
    export SSL_CERT_FILE='/home/ernest/.llmtrim/ca-bundle.pem'
    export CURL_CA_BUNDLE='/home/ernest/.llmtrim/ca-bundle.pem'
fi
# <<< llmtrim <<<
