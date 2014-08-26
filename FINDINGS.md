# Findings
Here are some findings from research into all of this stuff.

* Digium is the company that makes Asterisk
* Digium only supports LTS versions of Asterisk
* The latest LTS version of Asterisk is 11
* Version 11 doesn't support WebRTC until 11.11
* Version 11.11 only supports WebRTC Audio (minus opus codec)
* Version 12 is the latest full version of Asterisk
* Version 12 supports WebRTC Video and Audio
* The Video support is only with VP8 passthrough
* VP8 is the codec Chrome uses for Video
* Passthrough means the other endpoint being called must also support VP8
* Some PBX systems do transcoding where one codec in can be another codec out
* When compiling asterisk, there's a menuselect which requires your terminal to be a certain size
* In CentOS 6.5 this is easily changed by editing the /etc/grub.conf. It's not there in 7
* There are people that have created patches for specific versions of Asterisk for WebRTC (on github).
* Linphone is an opensource SIP Softphone that supports VP8 and Opus. It's also cross-platform.
