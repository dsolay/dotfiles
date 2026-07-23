#! /bin/sh

# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/.local/share/kiro-cli/shell/profile.pre.bash" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/profile.pre.bash"


# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# unclock keyring for terminal sessions
# see https://wiki.archlinux.org/index.php/GNOME/Keyring#With_a_display_manager
if [ -n "$DESKTOP_SESSION" ]; then
    eval "$(gnome-keyring-daemon --start --daemonize)"
    export SSH_AUTH_SOCK
fi


# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/.local/share/kiro-cli/shell/profile.post.bash" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/profile.post.bash"
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
