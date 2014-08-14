# CentOS 6.5 64bit for VirtualBox with Asterisk Setup

__(as root)__

### Setup Network config
1. `vi /etc/sysconfig/network-scripts/ifcfg-eth0`
2. Update file to have `DEVICE=eth0` `BOOTPROTO=dhcp` `ONBOOT=yes` `NM_CONTROLLED=no` `HWADDR=YOUR MAC ADDRESS` Check virtualbox settings under network for macaddress. Be sure to use : separation format
3. `service network restart`
4. `ifconfig | grep "inet addr"` Check for IP address

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

### Install Asterisk 11.11.x
26. `yum install -y wget gcc-c++ ncurses-devel libxml2-devel sqlite-devel libsrtp-devel libuuid-devel openssl-devel iksemel-devel`
27. `cd /usr/local/src/`
28. `wget http://downloads.asterisk.org/pub/telephony/dahdi-linux/releases/dahdi-linux-2.9.2.tar.gz`
28. `wget http://downloads.asterisk.org/pub/telephony/dahdi-tools/releases/dahdi-tools-2.9.2.tar.gz`
29. `wget http://downloads.asterisk.org/pub/telephony/libpri/releases/libpri-1.4.15.tar.gz`
30. `wget http://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-11.11.0.tar.gz`
31. `tar zxvf dahdi-linux*`
32. `cd dahdi-linux*`
33. `make && make install && make config`
34. `cd ..`
35. `tar zxvf dahdi-tools*`
36. `cd dahdi-tools*`
37. `make && make install && make config`
38. `cd ..`
36. `tar zxvf libpri*`
37. `cd libpri*`
38. `make && make install`
39. `cd ..`
40. `tar zxvf asterisk*`
41. `cd asterisk*`
42. `./configure --libdir=/usr/lib64`
43. `make menuselect`
44. Select `Resource Modules` then scroll down to ensure a * is next to `res_srtp`. Press `x` to save & quit
45. `make && make install`
46. `make samples`
47. `make config`

### Configure Asterisk for WebRTC
48. `mkdir /etc/asterisk/keys`
49. `/cd /usr/local/src/asterisk*/contrib/scripts`
50. `./ast_tls_cert -C $(currip) -O "My Super Company" -d /etc/asterisk/keys`
51. `vi /etc/asterisk/http.conf`
```
[general]
enabled=yes
bindaddr=127.0.0.1 ; Replace this with your IP address
bindport=8088 ; Replace this with the port you want to listen on
```
  * save & exit
52. `vi /etc/asterisk/sip.conf`
```
[general]
realm=127.0.0.1 ; Replace this with your IP address
udpbindaddr=127.0.0.1 ; Replace this with your IP address
transport=udp
;
[1060] ; This will be WebRTC client
type=friend
username=1060 ; The Auth user for SIP.js
host=dynamic ; Allows any host to register
secret=password ; The SIP Password for SIP.js
encryption=yes ; Tell Asterisk to use encryption for this peer
avpf=yes ; Tell Asterisk to use AVPF for this peer
icesupport=yes ; Tell Asterisk to use ICE for this peer
context=default ; Tell Asterisk which context to use when this peer is dialing
directmedia=no ; Asterisk will relay media for this peer
transport=udp,ws ; Asterisk will allow this peer to register on UDP or WebSockets
force_avp=yes ; Force Asterisk to use avp. Introduced in Asterisk 11.11
dtlsenable=yes ; Tell Asterisk to enable DTLS for this peer
dtlsverify=no ; Tell Asterisk to not verify your DTLS certs
dtlscertfile=/etc/asterisk/keys/asterisk.pem ; Tell Asterisk where your DTLS cert file is
dtlsprivatekey=/etc/asterisk/keys/asterisk.pem ; Tell Asterisk where your DTLS private key is
dtlssetup=actpass ; Tell Asterisk to use actpass SDP parameter when setting up DTLS
;
[1061] ; This will be the legacy SIP client
type=friend
username=1061
host=dynamic
secret=password
context=default
```
  * save & exit
53. `vi /etc/asterisk/extensions.conf`
```
[default]
exten => 1060,1,Dial(SIP/1060) ; Dialing 1060 will call the SIP client registered to 1060
exten => 1061,1,Dial(SIP/1061) ; Dialing 1061 will call the SIP client registered to 1061
```
54. `vi /etc/asterisk/manager.conf`
```
[general]
enabled=yes
port=5038
bindaddr=0.0.0.0
;
[admin]
secret=password
read=all
write=all
writetimeout=5000
```
55. `service asterisk restart`
