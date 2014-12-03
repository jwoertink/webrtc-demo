# Findings
Here are some findings from research into all of this stuff.

* Digium is the company that makes Asterisk
* Digium only supports LTS versions of Asterisk
* The latest LTS version of Asterisk is 13
* Version 11 doesn't support WebRTC until 11.11
* Version 11.11 only supports WebRTC Audio (minus opus codec)
* Version 13 is the latest full version of Asterisk
* Version 12+ supports WebRTC Video and Audio
* The Video support is only with VP8 passthrough
* VP8 is the codec Chrome uses for Video
* Firefox 33+ supports VP8 and Open H.264
* Passthrough means the other endpoint being called must also support VP8
* Some PBX systems do transcoding where one codec in can be another codec out
* When compiling asterisk, there's a menuselect which requires your terminal to be a certain size
* In CentOS 6.5 this is easily changed by editing the /etc/grub.conf. It's not there in 7
* There are people that have created patches for specific versions of Asterisk for WebRTC (on github).
* Linphone is an opensource SIP Softphone that supports VP8 and Opus. It's also cross-platform.
* Most softphones only support SIP SIMPLE messaging for presence. The standard though is XMPP
* Setting up VirtualBox on OSX may run into some issues with using a Bridged network. If this is the case, you can use NAT, then set your network config (in CentOS) to use `BOOTPROTO=dhcp` along with a few other small changes. Then just use the port forwarding option in VirtualBox to access everything from OSX.
* XMPP support requires the `iksemel-devel` package on CentOS, but fails to compile on CentOS 7 because it's so old.
* Asterisk 13 uses pjsip as the SIP driver, but it doesn't automatically configure this for you
* Asterisk 12.7 works best with WebRTC (so far)
* FreePBX is a web gui interface for asterisk, but it's missing features WebRTC needs like configuring TLS certs, and setting transport to ws or wss.
* FreePBX may have add-ons, but this is not available out of the box.
