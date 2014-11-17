# Getting started with WebRTC

### Dependencies
1. [Download CentOS 6.5](http://isoredirect.centos.org/centos/6/isos/x86_64/) - I used the DVD1to2.torrent, but I think the main install is just DVD1
2. [Download Virtualbox](https://www.virtualbox.org/wiki/Downloads)
3. [Download Linphone](http://www.linphone.org/downloads-for-desktop.html)

### VirtualBox Config
1. Make a new VM
2. Select `Linux` and `RedHat 64`
3. Click VM and select Settings
4. Click Storage
5. Click CD icon
6. CD/DVD Drive: IDE Primary Master (click little icon and select DVD1 CentOS iso)
7. Click Network
8. Select Attached to Bridged Adapter
9. Click `ok` and boot that bad boy.

### Installing CentOS
1. follow directions
2. When installed and booted open the `centos6-5-VBoxInstall.md` file
3. follow more directions

### Running the sample app
1. It's a [Sinatra](http://sinatrarb.com/) app. So install ruby, and bundle.
2. Run `rackup` from the app directory
