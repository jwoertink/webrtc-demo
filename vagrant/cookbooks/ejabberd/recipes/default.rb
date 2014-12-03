require 'json'
# Seems to be an error with data_bag
# can't convert Array into String
# def data_bag_items(bag_name)
#   data_bag(bag_name).collect { |id| data_bag_item(bag_name, id) }
# end

def read_data_bag(bag_name)
  file = File.join(File.dirname(__FILE__), '..', 'data_bags', "#{bag_name}.json")
  JSON.parse(IO.read(file))
end

users = read_data_bag(:users)

yum_package 'ejabberd'

template "/etc/ejabberd/ejabberd.cfg" do
  source 'ejabberd.cfg.erb'
  mode 0644
  variables({
    host: node.ejabberd.host,
    host_ip: node.ejabberd.host_ip
  })
end

service "ejabberd" do
  action :restart
end

users.each do |user|
  execute "ejabberdctl register #{user['username']} #{node.ejabberd.host} #{user['password']}"
end

# Start ejabberd at startup
execute "chkconfig --add ejabberd"
execute "chkconfig ejabberd on"
