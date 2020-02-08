#!/bin/sh

# this file is executed when calling startx

# To run a different WM, set session="WM" below, or run:
#    startx ~/.xinitrc WM


# Session to run if none passed via startx
#DEFAULT_SESSION='bspwm' "'i3 --shmlog-size 0'
SESSION=${1:-bspwm}

# export WM=$session

# non-reparenting window managers/Grey window/Programs not drawing properly
export _JAVA_AWT_WM_NONREPARENTING=1

# Default Arch xinit scripts
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*.sh; do
        [ -x "$f" ] && . "$f"
    done
fi

# user init scripts and settings
[ -f /etc/X11/xinit/.Xmodmap ] && xmodmap /etc/X11/xinit/.Xmodmap
[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources
[ -f ~/.xprofile ] && source ~/.xprofile
[ -f ~/.profile ] && source ~/.profile

# display timeout and sleep
xset s 3600 3600
xset dpms 3600 3700 4000

# keyboard repeat rate
xset r rate 400 50
kbdrate -d 400 -r 50
# setxkbmap -model pc105 -layout us,es -variant ,deadtilde -option grp:alt_shift_toggle

# simulate Alt+F1 with just pressing Super
if hash ksuperkey &>/dev/null; then
    ksuperkey -e 'Super_L=Alt_L|F1' &
    ksuperkey -e 'Super_R=Alt_L|F1' &
fi

# Fonts
xset +fp /home/ernest/.local/share/fonts
xset fp rehash

# 1/1 mouse acceleration
xset m 1/1

# Cursor arrow shape
xsetroot -cursor_name left_ptr


# Display driver
# nvidia-settings --load-config-only
# nvidia-settings -a InitialPixmapPlacement=2

# Do NOT put commands below the exec lines
exec_session(){
	case $SESSION in
		bspwm) exec bspwm ;;
		i3|i3wm) exec i3 --shmlog-size 0 ;;
		mate) exec mate-session ;;
		*) exec bspwm ;;
	esac
}

exec_session