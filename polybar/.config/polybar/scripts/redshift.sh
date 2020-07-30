#!/bin/sh

function toggle_redshift() {
	if [[ $(pidof redshift) ]]; then
		pkill redshift
	else
		redshift &
	fi
	print_icon
}

function print_icon() {
  if [[ $(pidof redshift) ]]; then
   echo ""
  else
   echo ""
  fi
}

# Catch command line options
case $1 in
	-t|--toggle)
		toggle_redshift
		;;
	*)
		print_icon
		;;
esac
