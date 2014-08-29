# CentOS 6.5 64bit for VirtualBox with FreeSWITCH Setup
**UNTESTED**

__(as root)__

### Setup Network config
1. `vi /etc/sysconfig/network-scripts/ifcfg-eth0`
2. Update file to have `DEVICE=eth0` `BOOTPROTO=dhcp` `ONBOOT=yes` `NM_CONTROLLED=no` `HWADDR=YOUR MAC ADDRESS` Check virtualbox settings under network for macaddress. Be sure to use : separation format
3. `service network restart`
4. `ifconfig | grep "inet addr"` Check for IP address
5. `service iptables save`
6. `service iptables stop`
7. `chkconfig iptables off`

### Install Virtualbox Guest Additions
5. Devices > Insert Guest Additions CD Image
6. `mkdir /media/VirtualBoxGuestAdditions`
7. `mount -r /dev/cdrom /media/VirtualBoxGuestAdditions`
8. `yum update -y`
9. `yum groupinstall -y "Development Tools"`
10. `rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm`
11. `yum install -y gcc kernel-devel kernel-headers dkms make bzip2 perl`
12. `yum install -y kernel-devel-$(uname -r) kernel-headers-$(uname -r)`
13. `KERN_DIR=/usr/src/kernels/$(uname -r)/`
14. `export KERN_DIR`
15. `cd /media/VirtualBoxGuestAdditions`
16. `./VBoxLinuxAdditions.run`
17. `reboot`

### Configure Terminal
18. `vi /etc/grub.conf`
19. Find the kernel line and add `vga=791` to the end of the line
20. `vi /etc/bashrc`
21. update PS1 to `PS1='\[\033[02;32m\]\u@\h\[\033[02;34m\]\w\$\[\033[00m\] '`
22. add `alias currip="ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{print \$1}'"`
23. save and exit
24. `sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config`
25. `reboot`

### Install FreeSWITCH
26. `rpm -ivh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm`
27. `yum install -y git gcc-c++ autoconf automake livtool wget python ncurses-devel libjpeg-devel openssl-devel e2fsprogs-devel sqlite-devel libcurl-devel pcre-devel speex-devel ldns-devel libedit-devel postgresql-libs.x86_64 postgresql-devel.x86_64`
28. `cd /usr/local/src/`
29. `git clone https://stash.freeswitch.org/scm/fs/freeswitch.git`
30. `cd freeswitch`
31. `./boostrap.sh -j`
32. `vi modules.conf` Add or remove modules
33. `./configure --enable-core-pgsql-support`
34. `make && make install`
