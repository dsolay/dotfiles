#!/bin/bash

# Functions
# =========

_checkexec() {
  command -v "$1" > /dev/null
}

# Append our default paths
appendpath () {
  case ":$PATH:" in
    *:"$1":*)
      ;;
    *)
      PATH="${PATH:+$PATH:}$1"
  esac
}

prependpath () {
  case ":$PATH:" in
    *:"$1":*)
      ;;
    *)
      PATH="$1:${PATH:+$PATH}"
  esac
}

# Colourise man pages
man() {
  env \
    LESS_TERMCAP_mb="$(tput bold; tput setaf 6)" \
    LESS_TERMCAP_md="$(tput bold; tput setaf 6)" \
    LESS_TERMCAP_me="$(tput sgr0)" \
    LESS_TERMCAP_se="$(tput rmso; tput sgr0)" \
    LESS_TERMCAP_ue="$(tput rmul; tput sgr0)" \
    LESS_TERMCAP_us="$(tput smul; tput bold; tput setaf 4)" \
    LESS_TERMCAP_mr="$(tput rev)" \
    LESS_TERMCAP_mh="$(tput dim)" \
    LESS_TERMCAP_ZN="$(tput ssubm)" \
    LESS_TERMCAP_ZV="$(tput rsubm)" \
    LESS_TERMCAP_ZO="$(tput ssupm)" \
    LESS_TERMCAP_ZW="$(tput rsupm)" \
    man "$@"
  }

# Back up a file. Usage "backupthis <filename>"
backupthis() {
  cp -riv "$1" "${1}-$(date +%Y%m%d%H%M)".backup;
}

# shell helper functions
# mostly written by Nathaniel Maia, some pilfered from around the web

# better ls and cd
unalias ls >/dev/null 2>&1
ls()
{
  command ls --color=auto -F "$@"
}

unalias cd >/dev/null 2>&1
# Enter directory and list contents
cd() {
  if [ -n "$1" ]; then
    builtin cd "$@" && ls -pvA --color=auto --group-directories-first
  else
    builtin cd ~ && ls -pvA --color=auto --group-directories-first
  fi
}

src()
{
  # shellcheck source=../.bashrc
  source ~/.bashrc 2> /dev/null
}

por()
{
  local orphans
  orphans="$(pacman -Qtdq 2>/dev/null)"
  if [[ -z $orphans ]];
  then
    printf "System has no orphaned packages\n"
  else
    sudo pacman -Rns "$orphans"
  fi
}

pss()
{
  PS3=$'\n'"Enter a package number to install, Ctrl-C to exit"$'\n\n'">> "
  select pkg in $(pacman -Ssq "$1"); do sudo pacman -S "$pkg"; break; done
}

pacsearch()
{
  echo -e "$(pacman -Ss "$@" | sed \
    -e 's#core/.*#\\033[1;31m&\\033[0;37m#g' \
    -e 's#extra/.*#\\033[0;32m&\\033[0;37m#g' \
    -e 's#community/.*#\\033[1;35m&\\033[0;37m#g' \
    -e 's#^.*/.* [0-9].*#\\033[0;36m&\\033[0;37m#g')"
  }

tmuxx()
{
  if [[ -z $TMUX ]]; then
    tmux new
  fi
}

surfs()
{
  if ! hash surf-open tabbed surf >/dev/null 2>&1; then
    local reqs="tabbed, surf, surf-open (shell script provided with surf)"
    printf "error: this requires the following installed\n\n\t%s\n" "$reqs"
    return 1
  fi

  declare -a urls
  if (( $# == 0 )); then
    local main="https://www.google.com"
    urls=("https://www.youtube.com"
      "https://forum.archlabslinux.com"
      "https://bitbucket.org"
      "https://suckless.org"
    )
  else
    local main="$1"
    shift
    for arg in "$@"; do
      urls+=("$arg")
    done
  fi

  (
  surf-open "$main" &
  sleep 0.1
  for url in "${urls[@]}"; do
    surf-open "$url" &
  done
  ) & disown
}

flac_to_mp3()
{
  for i in "${1:-.}"/*.flac; do
    [[ -e "${1:-.}/$(basename "$i" | sed 's/.flac/.mp3/g')" ]] || ffmpeg -i "$i" -qscale:a 0 "${i/%flac/mp3}"
  done
}

deadsym()
{
  for i in **/*; do [[ -h $i && ! -e $(readlink -fn "$i") ]] && rm -rfv "$i"; done
}

gitpr()
{
  github="pull/$1/head:$2"
  _fetchpr "$github" "$2" "$3"
}

bitpr()
{
  bitbucket="refs/pull-requests/$1/from:$2"
  _fetchpr "$bitbucket" "$2" "$3"
}

_fetchpr()
{
  # shellcheck disable=2154
  [[ $ZSH_VERSION ]] && program=${funcstack#_fetchpr} || program='_fetchpr'
  if (( $# != 2 && $# != 3 )); then
    printf "usage: %s <id> <branch> [remote]" "$program"
    return 1
  else
    ref=$1
    branch=$2
    origin=${3:-origin}
    if git rev-parse --git-dir &> /dev/null; then
      git fetch "$origin" "$ref" && git checkout "$branch"
    else
      echo 'error: not in git repo'
    fi
  fi
}

sloc()
{
  [[ $# -eq 1 && -r $1 ]] || { printf "Usage: sloc <file>"; return 1; }
  if [[ $1 == *.vim ]]; then
    awk '!/^[[:blank:]]*("|^$)/' "$1" | wc -l
  elif [[ $1 =~ (\.c|\.h|\.j) ]]; then
    awk '!/^[[:blank:]]*(\/\/|\*|\/\*|^$)/' "$1" | wc -l
  else
    awk '!/^[[:blank:]]*(\/\/|#|\*|\/\*|^$)/' "$1" | wc -l
  fi
}

nh()
{
  nohup "$@" &>/dev/null &
}

hex2dec()
{
  awk 'BEGIN { printf "%d\n",0x$1}'
}

dec2hex()
{
  awk 'BEGIN { printf "%x\n",$1}'
}

mktar()
{
  tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"
}

mkzip()
{
  zip -r "${1%%/}.zip" "$1"
}

sanitize()
{
  chmod -R u=rwX,g=rX,o= "$@"
}

mp()
{
  ps "$@" -u "$USER" -o pid,%cpu,%mem,bsdtime,command
}

pp()
{
  mp f | awk '!/awk/ && $0~var' var="${1:-".*"}"
}

ff()
{
  find . -type f -iname '*'"$*"'*' -ls
}

fe()
{
  find . -type f -iname '*'"${1:-}"'*' -exec "${2:-file}" {} \;
}

ranger()
{
  local dir tmpf
  [[ $RANGER_LEVEL && $RANGER_LEVEL -gt 2 ]] && exit 0
  local rcmd="command ranger"
  [[ $TERM == 'linux' ]] && rcmd="command ranger --cmd='set colorscheme default'"
  tmpf="$(mktemp -t tmp.XXXXXX)"
  eval "$rcmd --choosedir='$tmpf' '${*:-$(pwd)}'"
  [[ -f $tmpf ]] && dir="$(cat "$tmpf")"
  [[ -e $tmpf ]] && rm -f "$tmpf"
  [[ -z $dir || $dir == "$PWD" ]] || builtin cd "${dir}" || return 0
}

resize()
{
  hash convert >/dev/null 2>&1 || { printf "This function requires imagemagick\n"; return 1; }
  local size="$1"; shift
  if [[ $size =~ [1-9]*x[1-9] && $# -ge 1 ]]; then
    if [[ $# -gt 1 || -d "$1" ]]; then
      if [[ -d "$1" ]]; then
        for i in "$1"/*; do
          [[ $i =~ (.jpg|.png) ]] && convert "$i" -resize "$1" "$i"
        done
      else
        for i in "$@"; do
          [[ -f $i && $i =~ (.jpg|.png) ]] && convert "$i" -resize "$1" "$i"
        done
      fi
    else
      [[ -f $1 && $1 =~ (.jpg|.png) ]] && convert "$1" -resize "$1" "$1"
    fi
  else
    printf "Usage: resize [size] [directory or file(s)]\n\n%s\n" \
      "When given a directory, all images within will be converted"
  fi
}

fstr()
{
  OPTIND=1
  local case=""
  local usage='Usage: fstr [-i] "pattern" ["filename pattern"]'
  while getopts :it opt; do case "$opt" in
    i) case="-i " ;;
    *) printf "%s" "$usage"; return ;;
  esac done
  shift $((OPTIND - 1))
  [[ $# -lt 1 ]] && printf "fstr: find string in files.\n%s" "$usage"
  find . -type f -name "${2:-*}" -print 0 \
    | xargs -0 egrep --color=always -sn "${case}" "$1" 2>&- | more
}

swap()
{ # Swap 2 filenames around, if they exist
  local tmpf=tmp.$$
  [[ $# -ne 2 ]] && printf "swap: takes 2 arguments\n" && return 1
  [[ ! -e $1 ]] && printf "swap: %s does not exist\n" "$1" && return 1
  [[ ! -e $2 ]] && printf "swap: %s does not exist\n" "$2" && return 1
  mv "$1" $tmpf && mv "$2" "$1" && mv $tmpf "$2"
}

take()
{
  mkdir -p "$1"
  cd "$1" || return
}

csrc()
{
  [[ $1 ]] || { printf "Missing operand" >&2; return 1; }
  [[ -r $1 ]] || { printf "File %s does not exist or is not readable\n" "$1" >&2; return 1; }
  local out=${TMPDIR:-/tmp}/${1##*/}
  gcc "$1" -o "$out" && "$out"
  rm "$out"
  return 0
}

hr()
{
  local start=$'\e(0' end=$'\e(B' line='qqqqqqqqqqqqqqqq'
  local cols=${COLUMNS:-$(tput cols)}
  while ((${#line} < cols)); do line+="$line"; done
  printf '%s%s%s\n' "$start" "${line:0:cols}" "$end"
}

arc()
{
  arg="$1"; shift
  case $arg in
    -e|--extract)
      if [[ $1 && -e $1 ]]; then
        case $1 in
          *.tbz2|*.tar.bz2) tar xvjf "$1" ;;
          *.tgz|*.tar.gz) tar xvzf "$1" ;;
          *.tar.xz) tar xpvf "$1" ;;
          *.tar) tar xvf "$1" ;;
          *.gz) gunzip "$1" ;;
          *.zip) unzip "$1" ;;
          *.bz2) bunzip2 "$1" ;;
          *.7zip) 7za e "$1" ;;
          *.rar) unrar x "$1" ;;
          *) printf "'%s' cannot be extracted" "$1"
        esac
      else
        printf "'%s' is not a valid file" "$1"
        fi ;;
      -n|--new)
        case $1 in
          *.tar.*)
            name="${1%.*}"
            ext="${1#*.tar}"; shift
            tar cvf "$name" "$@"
            case $ext in
              .gz) gzip -9r "$name" ;;
              .bz2) bzip2 -9zv "$name"
            esac ;;
          *.gz) shift; gzip -9rk "$@" ;;
          *.zip) zip -9r "$@" ;;
          *.7z) 7z a -mx9 "$@" ;;
          *) printf "bad/unsupported extension"
        esac ;;
      *) printf "invalid argument '%s'" "$arg"
    esac
  }

vbump()
{
  [[ -f PKGBUILD ]] || return 1
  # shellcheck disable=1091
  . PKGBUILD
  # shellcheck disable=2154
  new=$((pkgrel + 1))
  sed -i "s/^pkgrel=.*/pkgrel=$new/" PKGBUILD
  printf ">>>  Old pkgrel was: %s .. Updated to: %s\n" "$pkgrel" "$new"
}

killp()
{
  local pid name sig="-TERM"   # default signal
  [[ $# -lt 1 || $# -gt 2 ]] && printf "Usage: killp [-SIGNAL] pattern" && return 1
  [[ $# -eq 2 ]] && sig=$1
  for pid in $(mp | awk '!/awk/ && $0~pat { print $1 }' pat=${!#}); do
    name=$(mp | awk '$1~var { print $5 }' var="$pid")
    ask "Kill process $pid <$name> with signal $sig?" && kill "$sig" "$pid"
  done
}

mdf()
{
  local cols
  cols=$(( ${COLUMNS:-$(tput cols)} / 3 ))
  for fs in "$@"; do
    [[ ! -d $fs ]] && printf "%s :No such file or directory" "$fs" && continue
    IFS=" "
    read -r -a info <<< "$(command df -P "$fs" | awk 'END{ print $2,$3,$5 }')"
    read -r -a free <<< "$(command df -Pkh "$fs" | awk 'END{ print $4 }')"
    local nbstars=$((cols * info[1] / info[0]))
    local out="["
    for ((i=0; i<cols; i++)); do
      [[ $i -lt $nbstars ]] && out=$out"*" || out=$out"-"
    done
    out="${info[2]} $out] (${free[*]} free on $fs)"
    printf "%s\n" "$out"
  done
}

mip()
{
  LANIFACE=$(ip route get 1.1.1.1  |grep -oP 'dev\s+\K[^ ]+')
  ip4=$(ip -4 addr show "$LANIFACE" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
  ip4_public=$(curl --silent ipinfo.io/ip)
  ip6=$(ip -6 addr show "$LANIFACE" | grep -oP '(?<=inet6\s)[\da-f:]+')

  printf "%s\n" "IPv4: ${ip4:-Not connected}"
  printf "%s\n" "Public IPv4: ${ip4_public:-Not connected}"
  printf "%s\n" "IPv6: ${ip6:-Not connected}"
}

ii()
{
  echo -e "\nYou are logged on \e[1;31m$HOSTNAME"
  echo -e "\n\e[1;31mAdditionnal information:\e[m " ; uname -a
  echo -e "\n\e[1;31mUsers logged on:\e[m "         ; w -hs | awk '{print $1}' | sort | uniq
  echo -e "\n\e[1;31mCurrent date:\e[m "            ; date
  echo -e "\n\e[1;31mMachine stats:\e[m "           ; uptime
  echo -e "\n\e[1;31mMemory stats:\e[m "            ; free -h
  echo -e "\n\e[1;31mDiskspace:\e[m "               ; mdf / "$HOME"
  echo -e "\n\e[1;31mLocal IP Address:\e[m"         ; mip
  echo -e "\n\e[1;31mOpen connections:\e[m "        ; ss -lt;
  echo
}

rep()
{
  local max=$1
  shift
  for (( i=0; i<max; i++ )); do
    eval "$@"
  done
}

ask()
{
  printf "%s" "$@" '[y/N] '; read -r ans
  case "$ans" in
    y*|Y*) return 0 ;;
    *) return 1
  esac
}

args()
{
  # Bash or ksh93 debugging function for colored display of argv.
  # Optionally set OFD to the desired output file descriptor.
  { BASH_XTRACEFD=3 eval ${BASH_VERSION+"$(</dev/fd/0)"}; } <<-'EOF' 3>/dev/null
                case $- in *x*)
                        set +x
                        trap 'trap RETURN; set -x' RETURN
                    esac
EOF

[[ ${OFD-1} == +([0-9]) ]] || return

if [[ -t ${OFD:-2} ]]; then
  typeset -A clr=([green]=$(tput setaf 2) [sgr0]=$(tput sgr0))
else
  typeset clr
fi

if ! ${1+false}; then
  printf -- "${clr[green]}<${clr[sgr0]}%s${clr[green]}>${clr[sgr0]} " "$@"
  echo
else
  echo 'no args.'
  fi >&"${OFD:-2}"
}

fast_chr()
{
  local __octal
  local __char
  printf -v __octal '%03o' "$1"
  printf -v __char "%s" "\\\\$__octal"
  REPLY=$__char
}

unichr()
{
  if [[ $# -lt 1 || $1 =~ (-h|--help) ]]; then
    cat << EOF
Usage example:
        for (( i=0x2500; i<0x2600; i++ )); do
            unichr $i
          done
EOF
  fi

  local c=$1  # Ordinal of char
  local l=0   # Byte ctr
  local o=63  # Ceiling
  local p=128 # Accum. bits
  local s=''  # Output string

  (( c < 0x80 )) && { fast_chr "$c"; echo -n "$REPLY"; return; }

  while (( c > o )); do
    fast_chr $(( t = 0x80 | c & 0x3f ))
    s="$REPLY$s"
    (( c >>= 6, l++, p += o + 1, o >>= 1 ))
  done

  # shellcheck disable=2034
  fast_chr $(( t = p | c ))
  echo -n "$REPLY$s"
}


genecho()
{
  # on the fly echo script generation with quoting
  {
    printf "#!/bin/bash\n\n"
    printf "echo "
    for arg; do
      arg=${arg/\'/\'\\\'\'}
      printf "'%s' " "${arg}"
    done
    printf "\n"
  } >s2
}

booting() {
  sudo dd bs=4M if="$1" of="${2}" conv=fsync oflag=direct status=progress
}

format() {
  sudo wipefs -a "$1" \
    && sudo parted -s "$1" mklabel msdos mkpart primary fat32 1MiB 100% \
    && sudo mkfs."${2}" -F 32 "${1}1"
}

genssl() {
  # openssl req -newkey rsa:4096 -x509 -sha256 -days 3650 -nodes -out $1.crt -keyout $1.key
  openssl genrsa -out "$1.key" 2048 \
    && openssl req -new -key "$1.key" -out "$1.csr" \
    && openssl x509 -req -days 365 -in "$1.csr" -signkey "$1.key" -out "$1.crt"
}


terminate() {
  for pid in $(pgrep "$1")
  do
    kill -9 "$pid"
  done
}

dlna() {
  [ -f ~/.config/minidlna/minidlna.log ] && rm ~/.config/minidlna/minidlna.log
  minidlnad -R \
    -f "/home/$USER/.config/minidlna/minidlna.conf" \
    -P "/home/$USER/.config/minidlna/minidlna.pid"
}

docker-ip() {
  sudo docker \
    inspect \
    --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
    "$@"
}

ssh-init() {
  if ps -p "$SSH_AGENT_PID" > /dev/null
  then
    echo "add ssh key..."
    ssh-add "$1"
  else
    echo "init ssh-agent..."
    eval "$(ssh-agent -s)"

    ssh-init "$@"
  fi
}

encrypt() {
  gpg --recipient "$1" --encrypt-files "$2"
}

decrypt() {
  gpg --decrypt-files "$1"
}

ekey() {
  gpg --export-secret-keys --armor "$1" > "$2/secret.asc"
  gpg --export --armor "$1" > "$2/public.asc"
}

usb-boot() {
  sudo qemu-system-x86_64 \
    -enable-kvm \
    -rtc base=localtime \
    -m "${2:-2G}" \
    -vga std \
    -drive file="$1",readonly=on,cache=none,format=raw,if=virtio
}

mnt-iso() {
  sudo mount -o loop "$1" "$2"
}

ftpm() {
  curlftpfs ftp://"$1":"$2"/ /media/ftp/
}

yss() {
  arg="$1"; shift
  case $arg in
    -e|--exact)
      yay -Ss "$1" | grep -E "$1($|\s)"
    ;;
    *)
      yay -Ss "$arg" | grep -w "$arg"
    ;;
  esac
}

# Expand an alias as text - https://unix.stackexchange.com/q/463327/143394
expand_alias() {
  if [[ -n $ZSH_VERSION ]]; then
    # shellcheck disable=2154  # aliases referenced but not assigned
    printf '%s\n' "${aliases[$1]}"
  else  # bash
    printf '%s\n' "${BASH_ALIASES[$1]}"
  fi
}

vercomp() {
  if [[ $1 == "$2" ]]
  then
    return 0
  fi
  local IFS=.
  local i ver1=("$1") ver2=("$2")
  # fill empty fields in ver1 with zeros
  for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
  do
    ver1[i]=0
  done
  for ((i=0; i<${#ver1[@]}; i++))
  do
    if [[ -z ${ver2[i]} ]]
    then
      # fill empty fields in ver2 with zeros
      ver2[i]=0
    fi
    if ((10#${ver1[i]} > 10#${ver2[i]}))
    then
      return 1
    fi
    if ((10#${ver1[i]} < 10#${ver2[i]}))
    then
      return 2
    fi
  done
  return 0
}

function testvercomp() {
  vercomp "$1" "$2"
  case $? in
    0) op='=';;
    1) op='>';;
    2) op='<';;
  esac
  if [[ $op != "$3" ]]
  then
    echo "FAIL: Expected '$3', Actual '$op', Arg1 '$1', Arg2 '$2'"
  else
    echo "Pass: '$1 $op $2'"
  fi
}

fix_gitignore() {
  git rm -r --cached .
  git add .
  git commit -m ".gitignore fix"
  echo "fix gitignore"
}

fix_ammend_pull() {
  git_version=$(git --version | cut -d " " -f 3)

  vercomp "$git_version" 2.23
  if [ $? -eq 2 ];
  then
    git checkout -b backup
    git branch -D "$1"
    git pull origin "$1"
    git checkout "$1"
  else
    git switch -c backup
    git branch -D "$1"
    git pull origin "$1"
    git switch "$1"
  fi
}

merge-pdf() {
  gs \
    -dBATCH -dNOPAUSE \
    -q -sDEVICE=pdfwrite \
    -dPDFSETTINGS=/prepress \
    -sOutputFile=merged.pdf "$@"
}

split-pdf() {
  gs -sDEVICE=pdfwrite \
    -q -dNOPAUSE -dBATCH \
    -sOutputFile=splited.pdf \
    -dFirstPage="$1" \
    -dLastPage="$2" \
    "$3"
}

compress-pdf() {
  gs -sDEVICE=pdfwrite \
    -dCompatibilityLevel="$2" \
    -dPDFSETTINGS=/prepress \
    -dNOPAUSE \
    -dQUIET \
    -dBATCH \
    -sOutputFile=compressed_PDF_file.pdf \
    "$1"
}

glNoGraph() {
  git log \
    --color=always \
    --format="%C(auto)%h%d %s %C(black)%C(bold)%cr% C(auto)%an" \
    "$@"
}

php-install()
{
  PHP_BUILD_CONFIGURE_OPTS="--enable-intl --with-pdo-pgsql --with-pgsql --with-pear" \
    phpenv install -f "$1"
}

run-windows() {
  sudo virsh start win10_21H2
  remote-viewer spice://127.0.0.1:5900 &
}

stop-windows() {
  sudo virsh shutdown win10_21H2
}

connect-room() {
ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)

nmcli con down "$ssid"
nmcli con up SolayRoom
}