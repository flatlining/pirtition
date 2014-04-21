#!/usr/bin/env bash


### Functions

function usage() {
  echo "Usage: ${0##*/} [[-h|--help] | [-i|--info] | [-s|--set partition]]"
}

function is_pi() {
  if [ -f "/boot/cmdline.txt" ]
  then
    return 0
  else
    return 1
  fi
}

function error_handling() {
  error_msg=""
  error_lvl=$1
  case "$1" in
    5)
      error_msg="you are not on a Raspberry Pi!"
      ;;
    *)
      error_msg="unknow error..."
      error_lvl=99
      ;;
  esac
  echo "${0##*/}: $error_msg"
  exit $error_lvl
}

function info_part() {
  echo "info"
}

function set_part() {
  echo "set"
}

### Main

if ! is_pi; then
  error_handling 5
fi

CMDLINE=`cat /boot/cmdline.txt`
CURRENT_ROOT=`lsblk -l -p -n -o NAME,TYPE,MOUNTPOINT,FSTYPE | grep part | grep -v vfat | grep "/ " | cut -d" " -f1`
ALLOWED_ROOT=(`lsblk -l -p -n -o NAME,TYPE,FSTYPE,SIZE | grep part | grep -v vfat | grep -v 1K | cut -d" " -f1`)

case "$1" in
  -s)
    set_part
  ;;
  *)
    usage
  ;;
esac
