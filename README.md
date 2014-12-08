# Getting started with WebRTC
There are 2 setups. The Manual setup, and the Vagrant setup.

## Manual Setup

### Dependencies
* [Download CentOS 6.5](http://isoredirect.centos.org/centos/6/isos/x86_64/) - I used the DVD1to2.torrent, but I think the main install is just DVD1
* [Download Virtualbox](https://www.virtualbox.org/wiki/Downloads)
* [Download Linphone](http://www.linphone.org/downloads-for-desktop.html)

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
10. When installed and booted open the `centos6-5-VBoxInstall-asterisk.md` file

## Vagrant Setup

### Dependencies
* [Vagrant](https://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Ansible](http://docs.ansible.com/intro_installation.html#installing-the-control-machine)

**note**: all `vagrant` commands should be run from the *vagrant* directory.

### Configuring
Edit the `vagrant/Vagrantfile` with your options, then take a look at the `playbook.yml` file to edit the options you need there.

### Building

`vagrant up`

### Destroying

`vagrant destroy`

### Logging in

`ssh root@IP_ADDRESS` password is "vagrant"

Optionally, you can use `vagrant ssh` to SSH as the "vagrant" user. Then use `sudo su -` to return to the root user.


## Running the sample app
1. It's a [Sinatra](http://sinatrarb.com/) app. So download and install ruby, then bundle.
2. Run `rackup` from the app directory


# Note
I haven't used FreeSwitch. I'd love to have some instructions on here, but someone will need to send a pull request. For now, everything will be based off Asterisk.
