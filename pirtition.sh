#!/usr/bin/env bash

# https://home.comcast.net/~dwm042/Standards.htm

##### Constants

PROGNAME=${0##*/}
PROGVERSION="0.0.1"

##### Functions

function usage_message()
{
  echo "Usage:
 $PROGNAME [[-i|--info] | [-s|--set <partition>]]"
}

function help_message()
{
  echo "
Define a new root partition on cmdline.txt for your Raspberry Pi
Can be in the memory card or in a connected usb memory

$(usage_message)

Options:
 -i, --info             display current configurations
 -s, --set <partition>  set new root partition
                        need's root privilege

 -h, --help             display this help and exit
 -V, --version          output version information and exit

Must be run with root privileges
Reboot to changes take effect
"
}

function version_message()
{
  echo "$PROGNAME version $PROGVERSION"
}

function is_pi()
{
  if [[ ( -f "/boot/bootcode.bin" ) && ( -f "/boot/start.elf" ) && ( -f "/boot/kernel.img" ) && ( -f "/boot/cmdline.txt" ) ]]
  then
    return 0
  else
    return 1
  fi
}

function error_handling()
{
  local error_msg=
  local error_lvl=$1
  case "$error_lvl" in
    5) error_msg="you are not on a Raspberry Pi!"
       ;;
    6) error_msg="you need to inform the new root partition"
       ;;
    7) error_msg="$2 is already the root partition"
       ;;
    8) error_msg="$2 is not a valid root partition candidate"
       ;;
    *) error_msg="unknow error..."
       error_lvl=1
       ;;
  esac
  echo "$PROGNAME: $error_msg"
  exit $error_lvl
}

function info_partition()
{
  echo "
Current root partition:
 $current_root

Partition candidates:
$(for _p in ${allowed_root[@]}; do echo " $_p"; done)
"
}

function set_partition()
{
  local new_partition=$1
  if [ -z $new_partition ]
  then
    error_handling 6
  fi
  if [ $new_partition == $current_root ]
  then
    error_handling 7 $new_partition
  fi
  # http://stackoverflow.com/a/15394738
  if [[ ! " ${allowed_root[@]} " =~ " $new_partition " ]]
  then
    error_handling 8 $new_partition
  fi

  local new_part_fs=`lsblk -l -p -o FSTYPE  -n $new_partition`
  local cur_part_fs=`lsblk -l -p -o FSTYPE  -n $current_root`

  local sed_expr="s/root=${current_root//\//\\/}/root=${new_partition//\//\\/}/g;s/rootfstype=$cur_part_fs/rootfstype=$new_part_fs/g"

  echo "Changing root partition: $current_root ($cur_part_fs) to $new_partition ($new_part_fs)..."
  sed -i $sed_expr /boot/cmdline.txt
  echo "Done! you should reboot now"
}

function load_root_data()
{
  current_root=`lsblk -l -p -n -o NAME,TYPE,MOUNTPOINT,FSTYPE | grep part | grep -v vfat | grep "/ " | cut -d" " -f1`
  allowed_root=(`lsblk -l -p -n -o NAME,TYPE,FSTYPE,SIZE | grep part | grep -v vfat | grep -v 1K | cut -d" " -f1`)
}

##### Main

if ! is_pi; then
  error_handling 5
fi

current_root=
allowed_root=

case $1 in
    -V | --version )     version_message
                         exit 1
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
