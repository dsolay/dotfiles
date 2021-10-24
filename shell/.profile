#! /bin/sh

appendpath()
{
  case ":$PATH:" in
  *:"$1":*)
    ;;
  *)
    PATH="${PATH:+$PATH:}$1"
    ;;
  esac
}

#Append our default paths
appendpath '/usr/local/sbin'
appendpath '/usr/local/bin'
appendpath '/usr/sbin'
appendpath '/usr/bin'
appendpath '/sbin'
appendpath '/bin'

umask 022

for script in /etc/profile.d/*.sh ; do
  if [ -r "$script" ] ; then
    # shellcheck source=/dev/null
    . "$script"
  fi
done