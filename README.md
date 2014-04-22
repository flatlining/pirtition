pirtition
=========

Root partition configuration tool for the Raspberry Pi

History
-------

When working with the Raspberry Pi I normally have both a system on the sd-card and a "test" system installed on a usb drive, this means that in a 
normal day of work I edit `/boot/cmdline.txt` when changing from one system to another.

Trying to make this task easier, and as a oportunity to improve my shell scripting skills, pirtition (pi + partition, get it?) was created, a 
simple tool to help change the root partion used for the Pi.

Instalation
===========

Pirtition is a shell script, you can clone the repository to your machine or simple copy the content of pirtition.sh to a local file, no hard to 
follow instructions here!

Usage
=====

You can use `pirtition.sh -h` for a parameter list, but currently there are only two parameters worth mentioning:

-i or --info
------------

Display information about the current state of your root partition, showing the current partition used as root and all the possible candidates to 
be used:

```
$ ./pirtition.sh -i

Current root partition:
 /dev/mmcblk0p5

Partition candidates:
 /dev/sda5
 /dev/mmcblk0p5

```

-s or --set
-----------

Set the new partition to be used as root (passed as parameter), you need root privileges to run this command successfully:

```
$ sudo ./pirtition.sh -s /dev/sda5
Changing root partition: /dev/mmcblk0p5 (ext4) to /dev/sda5 (ext4)...
Done! you should reboot now
```

Development
===========

Since I am a shell script newbie I can't garantee this tool won't screw your system badly, even if a backup copy of `cmdline.txt` would probably 
be enough to fix any erro, so be warned: **use it at your own risk**!

That been said I'm sharing the code to receive constructive feedback, so if you have any comment on the code, functionality or want to report a 
bug, feel free to use the [issue tracker](https://github.com/flatlining/pirtition/issues) or create a Pull Request.

Version History
---------------

See [CHANGELOG.md](CHANGELOG.md).

License
-------

Check back later!
