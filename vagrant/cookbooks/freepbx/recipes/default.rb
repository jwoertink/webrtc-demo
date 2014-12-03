# setup pear
execute 'pear channel-update pear.php.net'
execute 'pear install db'
execute 'adduser asterisk -M -c "Asterisk User"'

# ensure mysql is started
execute 'chkconfig --level 345 mysqld on'

service 'mysqld' do
  action :start
end

git node.freepbx.source_path do
  repository 'http://git.freepbx.org/scm/freepbx/framework.git'
  revision "release/#{node.freepbx.version}"
end

bash 'set ownership permissions' do
  user 'root'
  code <<-EOH
    chown asterisk. /var/run/asterisk
    chown -R asterisk. /etc/asterisk
    chown -R asterisk. /var/{lib,log,spool}/asterisk
    chown -R asterisk. /usr/lib64/asterisk
    chown -R asterisk. /var/www/
  EOH
end

bash 'modify apache' do
  user 'root'
  code <<-EOH
    sed -i 's/\(^upload_max_filesize = \).*/\120M/' /etc/php.ini
    cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf_orig
    sed -i 's/^\(User\|Group\).*/\1 asterisk/' /etc/httpd/conf/httpd.conf
  EOH
  notifies :restart, 'service[httpd]'
end

bash 'configure asterisk database' do
  user 'root'
  cwd node.freepbx.source_path
  code <<-EOH
    mysqladmin -u root create asterisk
    mysqladmin -u root create asteriskcdrdb
    mysql -u root -e "GRANT ALL PRIVILEGES ON asterisk.* TO asteriskuser@localhost IDENTIFIED BY '#{ENV['ASTERISK_DB_PW']}';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON asteriskcdrdb.* TO asteriskuser@localhost IDENTIFIED BY '#{ENV['ASTERISK_DB_PW']}';"
    mysql -u root -e "flush privileges;"
  EOH
end

bash 'install freepbx' do
  user 'root'
  cwd node.freepbx.source_path
  code <<-EOH
    ./install_amp --installdb --username=asteriskuser --password=#{node.freepbx.asterisk_db_password} --force-overwrite
    amportal chown
    amportal a ma installall
    amportal chown
    amportal a reload
    ln -s /var/lib/asterisk/moh /var/lib/asterisk/mohmp3
    amportal start
  EOH
end
