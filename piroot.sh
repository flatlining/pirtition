#!/usr/bin/env bash


### Functions

function usage_message() {
  echo "Usage: ${0##*/} [[-i|--info] | [-s|--set partition]]"
}

function help_message() {
  echo "help message()"
}

function version_message() {
  echo "version_message()"
}

function is_pi() {
  if [[ ( -f "/boot/bootcode.bin" ) && ( -f "/boot/start.elf" ) && ( -f "/boot/kernel.img" ) && ( -f "/boot/cmdline.txt" ) ]]
  then
    return 0
  else
    return 1
  fi
}

function error_handling() {
  local error_msg=
  local error_lvl=$1
  case "$1" in
    5)
      error_msg="you are not on a Raspberry Pi!"
      ;;
    *)
      error_msg="unknow error..."
      error_lvl=1
      ;;
  esac
  echo "${0##*/}: $error_msg"
  exit $error_lvl
}

function info_partition() {
  echo "info_partition()"
}

function set_partition() {
  echo "set_partition() $1"
}

function load_root_data() {
  current_root=`lsblk -l -p -n -o NAME,TYPE,MOUNTPOINT,FSTYPE | grep part | grep -v vfat | grep "/ " | cut -d" " -f1`
  allowed_root=(`lsblk -l -p -n -o NAME,TYPE,FSTYPE,SIZE | grep part | grep -v vfat | grep -v 1K | cut -d" " -f1`)
}

### Main

if ! is_pi; then
  error_handling 5
fi

#CMDLINE=`cat /boot/cmdline.txt`

current_root=
allowed_root=

case $1 in
    -V | --version )     version_message
                         exit
                         ;;
    -h | --help )        help_message
                         exit
                         ;;
    -i | --info )        load_root_data
                         info_partition
                         exit
                         ;;
    -s | --set )         shift
                         load_root_data
                         set_partition $1
                         exit
                         ;;            
     * )                 usage_message
                         exit 1
                         ;;
esac
