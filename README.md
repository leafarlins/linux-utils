# linux-utils
Usefull stuff for post-install linux.

## Problems

List of known problems.

#### Docker error in fedora 31

1. open `/etc/default/grub` as admin

2. Append value of GRUB_CMDLINE_LINUX with `systemd.unified_cgroup_hierarchy=0`

3. `sudo grub2-mkconfig > /boot/grub2/grub.cfg`

4. reboot
