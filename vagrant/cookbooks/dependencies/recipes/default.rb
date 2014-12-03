# Disabled the SELINUX
execute 'sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config'

# Shutdown the firewall stuff
service 'iptables' do
  action [:stop]
end
execute 'chkconfig iptables off'

# Update all the things
execute 'yum update -y'

# TODO: how to use rpm_package here?
execute 'rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm'

uname = Mixlib::ShellOut.new('uname -r')
uname.run_command
uname = uname.stdout.chomp

# All the dependencies for all cookbooks in this repo, even if it's not installed.
%W(
  audiofile-devel
  autoconf
  automake
  binutils
  bison
  bzip2
  cronie
  cronie-anacron
  crontabs
  dkms
  flex
  gcc
  gcc-c++
  gettext
  git
  gtk2-devel
  httpd
  iksemel-devel
  jansson-devel
  kernel-devel
  kernel-headers
  libsrtp-devel
  libtermcap-devel
  libtiff-devel
  libtool
  libuuid-devel
  libxml2-devel
  lynx
  make
  mysql-devel
  mysql-server
  ncurses-devel
  newt-devel
  openssl-devel
  patch
  perl
  php
  php-mbstring
  php-mysql
  php-pear
  php-process
  php-xml
  pkgconfig
  sendmail
  sendmail-cf
  sox
  sqlite-devel
  subversion
  tftp-server
  vim
  wget
).each(&method(:yum_package))

ENV['KERN_DIR'] = "/usr/src/kernels/#{uname}/"

# packages that cause issues. They don't seem to be needed
# gnutls-devel caching-nameserver
