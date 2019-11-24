# MIT (c) Wenxuan Zhang
forgit_warn() { printf "%b[Warn]%b %s\n" '\e[0;33m' '\e[0m' "$@" >&2; }
forgit_info() { printf "%b[Info]%b %s\n" '\e[0;32m' '\e[0m' "$@" >&2; }
forgit_inside_work_tree() { git rev-parse --is-inside-work-tree >/dev/null; }

hash fzf &>/dev/null || { forgit_warn "FZF not found and is requried for forgit"; return 1; }

# https://github.com/wfxr/emoji-cli
hash emojify &>/dev/null && forgit_emojify='|emojify'

forgit_pager=$(git config core.pager || echo 'cat')

# git commit viewer
forgit_log() {
    forgit_inside_work_tree || return 1
    local cmd opts
    cmd="echo {} |grep -Eo '[a-f0-9]+' |head -1 |xargs -I% git show --color=always % $* | $forgit_pager"
    opts="
        $FORGIT_FZF_DEFAULT_OPTS
        +s +m --tiebreak=index --preview=\"$cmd\"
        --bind=\"enter:execute($cmd | LESS='-R' less)\"
        --bind=\"ctrl-y:execute-silent(echo {} |grep -Eo '[a-f0-9]+' | head -1 | tr -d '\n' |${FORGIT_COPY_CMD:-pbcopy})\"
        $FORGIT_LOG_FZF_OPTS
    "
    eval "git log --graph --color=always --format='%C(auto)%h%d %s %C(black)%C(bold)%cr' $* $forgit_emojify" |
        FZF_DEFAULT_OPTS="$opts" fzf
}

# git diff viewer
forgit_diff() {
    forgit_inside_work_tree || return 1
    local cmd files opts commit
    [[ $# -ne 0 ]] && {
        if git rev-parse "$1" -- &>/dev/null ; then
            commit="$1" && files=("${@:2}")
        else
            files=("$@")
        fi
    }

    cmd="git diff --color=always $commit -- {} | $forgit_pager"
    opts="
        $FORGIT_FZF_DEFAULT_OPTS
        +m -0 --preview=\"$cmd\" --bind=\"enter:execute($cmd |LESS='-R' less)\"
        $FORGIT_DIFF_FZF_OPTS
    "
    cmd="echo" && hash realpath &>/dev/null && cmd="realpath --relative-to=."
    eval "git diff --name-only $commit -- ${files[*]}| xargs -I% $cmd '$(git rev-parse --show-toplevel)/%'"|
        FZF_DEFAULT_OPTS="$opts" fzf
}

# git add selector
forgit_add() {
    forgit_inside_work_tree || return 1
    local changed unmerged untracked files opts
    changed=$(git config --get-color color.status.changed red)
    unmerged=$(git config --get-color color.status.unmerged red)
    untracked=$(git config --get-color color.status.untracked red)

    opts="
        $FORGIT_FZF_DEFAULT_OPTS
        -0 -m --nth 2..,..
        --preview=\"git diff --color=always -- {-1} | $forgit_pager\"
        $FORGIT_ADD_FZF_OPTS
    "
    files=$(git -c color.status=always -c status.relativePaths=true status --short |
        grep -F -e "$changed" -e "$unmerged" -e "$untracked" |
        awk '{printf "[%10s]  ", $1; $1=""; print $0}' |
        FZF_DEFAULT_OPTS="$opts" fzf | cut -d] -f2 |
        sed 's/.* -> //') # for rename case
    [[ -n "$files" ]] && echo "$files" |xargs -I{} git add {} && git status --short && return
    echo 'Nothing to add.'
}

# git reset HEAD (unstage) selector
forgit_reset_head() {
    forgit_inside_work_tree || return 1
    local cmd files opts
    cmd="git diff --cached --color=always -- {} | $forgit_pager "
    opts="
        $FORGIT_FZF_DEFAULT_OPTS
        -m -0 --preview=\"$cmd\"
        $FORGIT_RESET_HEAD_FZF_OPTS
    "
    files="$(git diff --cached --name-only --relative | FZF_DEFAULT_OPTS="$opts" fzf)"
    [[ -n "$files" ]] && echo "$files" |xargs -I{} git reset -q HEAD {} && git status --short && return
    echo 'Nothing to unstage.'
}

# git checkout-restore selector
forgit_restore() {
    forgit_inside_work_tree || return 1
    local cmd files opts
    cmd="git diff --color=always -- {} | $forgit_pager"
    opts="
        $FORGIT_FZF_DEFAULT_OPTS
        -m -0 --preview=\"$cmd\"
        $FORGIT_CHECKOUT_FZF_OPTS
    "
    files="$(git ls-files --modified "$(git rev-parse --show-toplevel)"| FZF_DEFAULT_OPTS="$opts" fzf)"
    [[ -n "$files" ]] && echo "$files" |xargs -I{} git checkout {} && git status --short && return
    echo 'Nothing to restore.'
}

# git stash viewer
forgit_stash_show() {
    forgit_inside_work_tree || return 1
    local cmd opts
    cmd="git stash show \$(echo {}| cut -d: -f1) --color=always --ext-diff | $forgit_pager"
    opts="
        $FORGIT_FZF_DEFAULT_OPTS
        +s +m -0 --tiebreak=index --preview=\"$cmd\" --bind=\"enter:execute($cmd | LESS='-R' less)\"
        $FORGIT_STASH_FZF_OPTS
    "
    git stash list | FZF_DEFAULT_OPTS="$opts" fzf
}

# git clean selector
forgit_clean() {
    forgit_inside_work_tree || return 1
    local files opts
    opts="
        $FORGIT_FZF_DEFAULT_OPTS
        -m -0
        $FORGIT_CLEAN_FZF_OPTS
    "
    # Note: Postfix '/' in directory path should be removed. Otherwise the directory itself will not be removed.
    files=$(git clean -xdfn "$@"| awk '{print $3}'| FZF_DEFAULT_OPTS="$opts" fzf |sed 's#/$##')
    [[ -n "$files" ]] && echo "$files" |xargs -I% git clean -xdf % && return
    echo 'Nothing to clean.'
}

# git ignore generator
export FORGIT_GI_REPO_REMOTE=${FORGIT_GI_REPO_REMOTE:-https://github.com/dvcs/gitignore}
export FORGIT_GI_REPO_LOCAL=${FORGIT_GI_REPO_LOCAL:-~/.forgit/gi/repos/dvcs/gitignore}
export FORGIT_GI_TEMPLATES=${FORGIT_GI_TEMPLATES:-$FORGIT_GI_REPO_LOCAL/templates}

forgit_ignore() {
    [ -d "$FORGIT_GI_REPO_LOCAL" ] || forgit_ignore_update
    local IFS cmd args cat opts
    # https://github.com/sharkdp/bat.git
    hash bat &>/dev/null && cat='bat -l gitignore --color=always' || cat="cat"
    cmd="$cat $FORGIT_GI_TEMPLATES/{2}{,.gitignore} 2>/dev/null"
    opts="
        $FORGIT_FZF_DEFAULT_OPTS
        -m --preview=\"$cmd\" --preview-window='right:70%'
        $FORGIT_IGNORE_FZF_OPTS
    "
    # shellcheck disable=SC2206,2207
    IFS=$'\n' args=($@) && [[ $# -eq 0 ]] && args=($(forgit_ignore_list | nl -nrn -w4 -s'  ' |
        FZF_DEFAULT_OPTS="$opts" fzf  |awk '{print $2}'))
    [ ${#args[@]} -eq 0 ] && return 1
    # shellcheck disable=SC2068
    if hash bat &>/dev/null; then
        forgit_ignore_get ${args[@]} | bat -l gitignore
    else
        forgit_ignore_get ${args[@]}
    fi
}
forgit_ignore_update() {
    if [[ -d "$FORGIT_GI_REPO_LOCAL" ]]; then
        forgit_info 'Updating gitignore repo...'
        (cd "$FORGIT_GI_REPO_LOCAL" && git pull --no-rebase --ff) || return 1
    else
        forgit_info 'Initializing gitignore repo...'
        git clone --depth=1 "$FORGIT_GI_REPO_REMOTE" "$FORGIT_GI_REPO_LOCAL"
    fi
}
forgit_ignore_get() {
    local item filename header
    for item in "$@"; do
        if filename=$(find -L "$FORGIT_GI_TEMPLATES" -type f \( -iname "${item}.gitignore" -o -iname "${item}" \) -print -quit); then
            [[ -z "$filename" ]] && forgit_warn "No gitignore template found for '$item'." && continue
            header="${filename##*/}" && header="${header%.gitignore}"
            echo "### $header" && cat "$filename" && echo
        fi
    done
}
forgit_ignore_list() {
    find "$FORGIT_GI_TEMPLATES" -print |sed -e 's#.gitignore$##' -e 's#.*/##' | sort -fu
}
forgit_ignore_clean() {
    setopt localoptions rmstarsilent
    [[ -d "$FORGIT_GI_REPO_LOCAL" ]] && rm -rf "$FORGIT_GI_REPO_LOCAL"
}

# fbr - checkout git branch
forgit_checkout() {
  local branches branch
  branches=$(git --no-pager branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# fbr - checkout git branch (including remote branches)
forgit_checkout_all() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

FORGIT_FZF_DEFAULT_OPTS="
$FZF_DEFAULT_OPTS
--ansi
--height='80%'
--bind='alt-k:preview-up,alt-p:preview-up'
--bind='alt-j:preview-down,alt-n:preview-down'
--bind='ctrl-r:toggle-all'
--bind='ctrl-s:toggle-sort'
--bind='?:toggle-preview'
--bind='alt-w:toggle-preview-wrap'
--preview-window='right:60%'
$FORGIT_FZF_DEFAULT_OPTS
"

# register aliases
# shellcheck disable=SC2139
if [[ -z "$FORGIT_NO_ALIASES" ]]; then
    alias "${forgit_add:-ga}"='forgit_add'
    alias "${forgit_reset_head:-grh}"='forgit_reset_head'
    alias "${forgit_log:-glo}"='forgit_log'
    alias "${forgit_diff:-gd}"='forgit_diff'
    alias "${forgit_ignore:-gi}"='forgit_ignore'
    alias "${forgit_restore:-gcf}"='forgit_restore'
    alias "${forgit_clean:-gclean}"='forgit_clean'
    alias "${forgit_stash_show:-gss}"='forgit_stash_show'
    alias "${forgit_checkout:-fbr}"='forgit_checkout'
    alias "${forgit_checkout_all:-fbra}"='forgit_checkout_all'
fi
