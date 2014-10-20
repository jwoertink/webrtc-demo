# CentOS 6.5 64bit for VirtualBox with Asterisk Setup

__(as root)__

### Setup Network config
1. `vi /etc/sysconfig/network-scripts/ifcfg-eth0`
```
DEVICE=eth0
BOOTPROTO=static
DHCP_HOSTNAME=pbx.dev
HOSTNAME="pbx.dev"
IPV6INIT=yes
MTU=1500
NM_CONTROLLED=yes
ONBOOT=yes
TYPE=Ethernet
HWADDR=00:00:00:00:00 #YOUR MAC ADDRESS of VirtualBox
DNS1=8.8.8.8
USERCTL=no
IPADDR=0.0.0.0 #IP YOU NEED i.e. 172.16.1.56
NETMASK=255.255.255.0
GATEWAY=0.0.0.0 #YOUR GATEWAY i.e. 172.16.1.1
```
2. `service network restart` If any fail, you may need to run `reboot`
3. `ifconfig | grep "inet addr"` Check for IP address
4. `service iptables save`
5. `service iptables stop`
6. `chkconfig iptables off`

### Update Server Hostname
7. `vi /etc/sysconfig/network`
8. `HOSTNAME=pbx.dev` Set the HOSTNAME to `pbx.dev` or whatever you want your hostname to be
9. `vi /etc/hosts`
```
172.16.1.56 pbx.dev #use your IP address
127.0.0.1 localhost pbx.dev
::1 localhost pbx.dev
```
10. `hostname pbx.dev`
11. `service network restart`

### Install Virtualbox Guest Additions
7. Devices > Insert Guest Additions CD Image
8. `mkdir /media/VirtualBoxGuestAdditions`
9. `mount -r /dev/cdrom /media/VirtualBoxGuestAdditions`
10. `yum update -y`
11. `yum groupinstall -y "Development Tools"`
12. `rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm`
13. `yum install -y gcc kernel-devel kernel-headers dkms make bzip2 perl`
14. `yum install -y kernel-devel-$(uname -r) kernel-headers-$(uname -r)`
15. `KERN_DIR=/usr/src/kernels/$(uname -r)/`
16. `export KERN_DIR`
17. `cd /media/VirtualBoxGuestAdditions`
18. `./VBoxLinuxAdditions.run`
19. `reboot`

### Configure Terminal
20. `vi /etc/grub.conf`
21. Find the kernel line and add `vga=791` to the end of the line
22. `vi /etc/bashrc`
23. update PS1 to `PS1='\[\033[02;32m\]\u@\h\[\033[02;34m\]\w\$\[\033[00m\] '`
24. add `alias currip="ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{print \$1}'"`
25. save and exit
26. `sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config`
27. `reboot`

### Install Asterisk Current
28. `yum install -y wget gcc-c++ ncurses-devel libxml2-devel sqlite-devel libsrtp-devel libuuid-devel openssl-devel iksemel-devel jansson-devel`
29. `cd /usr/local/src/`
30. `wget downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-current.tar.gz`
31. `wget downloads.asterisk.org/pub/telephony/dahdi-tools/dahdi-tools-current.tar.gz`
32. `wget http://www.pjsip.org/release/2.2.1/pjproject-2.2.1.tar.bz2`
33. `wget downloads.asterisk.org/pub/telephony/libpri/libpri-1.4-current.tar.gz`
34. `wget downloads.asterisk.org/pub/telephony/asterisk/asterisk-12-current.tar.gz`
35. `tar zxvf dahdi-linux*`
36. `cd dahdi-linux*`
37. `make && make install && make config`
38. `cd ..`
39. `tar zxvf dahdi-tools*`
40. `cd dahdi-tools*`
41. `make && make install && make config`
42. `cd ..`
43. `tar zxvf libpri*`
44. `cd libpri*`
45. `make && make install`
46. `cd ..`
47. `tar -xjvf pjproject-2.2.1.tar.bz2`
48. `cd pjproject*`
49. `./configure --prefix=/usr/lib64/ --enable-shared`
50. `make dep`
51. `make && make install`
52. pjproject installs files to /usr/lib64/lib
53. `ldconfig`
54. `PKG_CONFIG_PATH=/usr/lib64/pkgconfig/`
55. `export PKG_CONFIG_PATH`
55. `cd ..`
56. `tar zxvf asterisk*`
57. `cd asterisk*`
58. `./configure --libdir=/usr/lib64`
59. `make menuselect`
60. Select `Resource Modules` then scroll down to ensure a * is next to `res_srtp`. Press `x` to save & quit
61. `vi include/asterisk/autoconfig.h` this is a super hack >_<
62. replace `#undef HAVE_PJ_TRANSACTION_GRP_LOCK` with `#define HAVE_PJ_TRANSACTION_GRP_LOCK 1`
63. `make && make install`
64. `make samples`
65. `make config`

### Configure Asterisk for WebRTC
66. `mkdir /etc/asterisk/keys`
67. `cd /usr/local/src/asterisk*/contrib/scripts`
68. `./ast_tls_cert -C $(currip) -O "My Super Company" -d /etc/asterisk/keys`
69. `vi /etc/asterisk/http.conf`
```
[general]
enabled=yes
bindaddr=127.0.0.1 ; Replace this with your IP address
bindport=8088 ; Replace this with the port you want to listen on
```
70. `vi /etc/asterisk/sip.conf`
```
[general]
context=default
allowguest=no
allowoverlap=no
accept_outofcall_message=yes
outofcall_message_context=default
realm=127.0.0.1 ; Replace this with your IP address
udpbindaddr=127.0.0.1 ; Replace this with your IP address
transport=ws,wss,udp
language=en
icesupport=yes
videosupport=yes
nat=auto_force_rport,auto_comedia
allow=!all,alaw,ulaw,gsm
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
transport=ws,wss,udp ; Asterisk will allow this peer to register on UDP or WebSockets
force_avp=yes ; Force Asterisk to use avp. Introduced in Asterisk 11.11
dtlsenable=yes ; Tell Asterisk to enable DTLS for this peer
dtlsverify=no ; Tell Asterisk to not verify your DTLS certs
dtlscertfile=/etc/asterisk/keys/asterisk.pem ; Tell Asterisk where your DTLS cert file is
dtlsprivatekey=/etc/asterisk/keys/asterisk.pem ; Tell Asterisk where your DTLS private key is
dtlssetup=actpass ; Tell Asterisk to use actpass SDP parameter when setting up DTLS
videosupport=yes
nat=no
disallow=all
allow=ulaw,vp8,h264
;
[1061] ; This will be the legacy SIP client
type=friend
username=1061
host=dynamic
secret=password
context=default
directmedia=no
transport=udp
force_avp=yes
dtlsenable=no
videosupport=yes
nat=no
disallow=all
allow=ulaw,vp8
```
71. `vi /etc/asterisk/extensions.conf`
```
[default]
exten => 1060,1,Dial(SIP/1060) ; Dialing 1060 will call the SIP client registered to 1060
exten => 1061,1,Dial(SIP/1061) ; Dialing 1061 will call the SIP client registered to 1061
```
72. `vi /etc/asterisk/manager.conf`
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
73. `service asterisk restart`
74. Ensure Linphone is installed, and all Video and Audio codecs are turned on
75. SIP account should be `sip:1061@CENT_OS_IP_ADDRESS` with `udp` transport

### Install & Configure ejabberd
76. `yum install -y ejabberd`
77. `vi /etc/ejabberd/ejabberd.cfg`
```
% Find this line and add the pbx.dev
{hosts, ["localhost", "pbx.dev"]}.
```
78. `service ejabberd start`
79. `ejabberdctl register admin pbx.dev password` to create an account called admin on pbx.dev with the password "password"
80. `vi /etc/ejabberd/ejabberd.cfg`
```
% This goes under the ACCESS CONTROL section
{acl, admin, {user, "admin", "pbx.dev"}}.
```
81. `service ejabberd restart`
82. Browse to `http://pbx.dev:5280/admin` and use admin/password to log in
83. Virtual Hosts > pbx.dev > Users - Make a user called "asterisk". Also make yourself a user
84. `vi /etc/asterisk/xmpp.conf`
```
[general]
autoregister=yes
autoprune-no
;
[ejabberd]
type=client
serverhost=pbx.dev
username=asterisk@pbx.dev
secret=password ;your password you chose for asterisk
priority=1
port=5222
usetls=no
usesasl=yes
status=available
statusmessage="It's Asterisk!"
timeout=5
```
85. `asterisk -r`
86. `module reload res_xmpp` - should show reloading
87. `xmpp show connections` - should show 1 client connected. If so, then `exit`
88. `vi /etc/asterisk/extensions.conf`
```
; replace the exten 1061 dialplan with this
exten => 1061,1,Set(JSTATUS=${JABBER_STATUS(ejabberd,youruser@pbx.dev/Desktop)}) ; /Desktop is the resource you will set in your xmpp client like Adium/Pidgin
same => n,GotoIf($[0${JSTATUS}=1]?available:unavailable)
same => n(available), JabberSend(ejabberd,youruser@pbx.dev,"Incoming call from ${CALLERID(num)}")
same => n,Dial(SIP/1061)
same => n,Hangup()
same => n(unavailable),JabberSend(ejabberd,youruser@pbx.dev,"Missed call from ${CALLERID(num)}")
; do other dialplan stuff when you're not available
```
89. `service asterisk restart`
