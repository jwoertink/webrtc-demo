default[:asterisk][:source_path]       = '/usr/local/src/'
default[:asterisk][:version]           = '12.7.1'
default[:asterisk][:source_url_prefix] = 'http://downloads.asterisk.org/pub/telephony/asterisk/'
default[:asterisk][:lib_dir]           = '/usr/lib64'
default[:asterisk][:install_samples]   = true
default[:asterisk][:keys_dir]          = '/etc/asterisk/keys'
default[:asterisk][:host]              = ENV['ASTERISK_HOST']
default[:asterisk][:hostname]          = ENV['VM_HOSTNAME']
default[:asterisk][:box_name]          = ENV['ASTERISK_BOX_NAME']
default[:asterisk][:data_path_prefix]  = ENV['ASTERISK_DATA_URL']
default[:asterisk][:stun_server]       = 'stun.l.google.com:19302'