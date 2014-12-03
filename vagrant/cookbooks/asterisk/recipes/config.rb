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

extensions = read_data_bag(:extensions)
managers = read_data_bag(:managers)
ejabberd = read_data_bag(:ejabberd)

template "/etc/asterisk/http.conf" do
  source 'http.conf.erb'
  mode 0644
  variables({
    host: node.asterisk.host
  })
end

template "/etc/asterisk/sip.conf" do
  source 'sip.conf.erb'
  mode 0644
  variables({
    host: node.asterisk.host,
    extensions: extensions,
    keys_dir: node.asterisk.keys_dir
  })
end

template "/etc/asterisk/pjsip.conf" do
  source 'pjsip.conf.erb'
  mode 0644
  variables({
    host: node.asterisk.host,
    extensions: extensions,
    keys_dir: node.asterisk.keys_dir
  })
end

template "/etc/asterisk/extensions.conf" do
  source 'extensions.conf.erb'
  mode 0644
  variables({
    extensions: extensions
  })
end

template "/etc/asterisk/manager.conf" do
  source 'manager.conf.erb'
  mode 0644
  variables({
    users: managers
  })
end

template "/etc/asterisk/rtp.conf" do
  source 'rtp.conf.erb'
  mode 0644
  variables({
    stun_server: node.asterisk.stun_server
  })
end

template "/etc/asterisk/xmpp.conf" do
  source 'xmpp.conf.erb'
  mode 0644
  variables({
    hostname: node.asterisk.hostname,
    user: ejabberd
  })
  notifies :reload, resources('service[asterisk]')
end
