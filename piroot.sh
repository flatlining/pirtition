#!/usr/bin/env bash

function usage() {
  echo "usage"
}

function is_pi() {
  if [ -f "/boot/cmdline.txt" ]
  then
    return 0
  else
    return 1
  fi
}

function info_part() {
  echo "info"
}

function set_part() {
  echo "set"
}

if ! is_pi; then
  echo "Not a raspberry pi"
  exit 1
fi

CMDLINE=`cat /boot/cmdline.txt`
CURRENT_ROOT=`lsblk -l -p -n -o NAME,TYPE,MOUNTPOINT,FSTYPE | grep part | grep -v vfat | grep "/ " | cut -d" " -f1`
ALLOWED_ROOT=(`lsblk -l -p -n -o NAME,TYPE,FSTYPE,SIZE | grep part | grep -v vfat | grep -v 1K | cut -d" " -f1`)

case "$1" in
  -s)
    set_part
  ;;
  *)
    info_part
  ;;
esac
