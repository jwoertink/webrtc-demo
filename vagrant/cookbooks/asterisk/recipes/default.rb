chef_gem 'ruby_expect'

source_tarball = "asterisk-#{node.asterisk.version}.tar.gz"
source_checksum = "asterisk-#{node.asterisk.version}.sha256"

source_url = node.asterisk.source_url_prefix + source_tarball
checksum_url = node.asterisk.source_url_prefix + source_checksum
tarball_path = node.asterisk.source_path + source_tarball

remote_file tarball_path do
  source source_url
  checksum checksum_url
  backup false
  # This will call the next ruby block
  # notifies :create, 'ruby_block[validate asterisk tarball]', :immediately
end

# Uncomment if you want to take the time to validate the tarball. It's slow....
# ruby_block 'validate asterisk tarball' do
#   block do
#     require 'digest'
#     require 'open-uri'
#     # chksum = open(checksum_url).read
#     # expected = chksum.split(' ').first
#     # actual = Digest::SHA256.file(tarball_path).hexdigest
#     # if expected and actual != expected
#     #   raise "Checksum mismatch on #{tarball_path}. Expected sha256 of #{expected} but found #{actual} instead"
#     # end
#   end
#   action :nothing
# end

bash 'install asterisk' do
  user 'root'
  cwd File.dirname(tarball_path)
  code <<-EOH
    tar zxf #{tarball_path}
    cd asterisk-#{node.asterisk.version}*
    ./contrib/scripts/install_prereq install
    ./configure --libdir=#{node.asterisk.lib_dir}
    make
    make install
    make config
    #{'make samples' if node.asterisk.install_samples}
    ldconfig
  EOH
  notifies :reload, 'service[asterisk]'
end

# This doesn't generate the keys properly
# TODO: fix this.
# directory node.asterisk.keys_dir do
#   recursive true
#   notifies :create, 'ruby_block[create asterisk keys]', :immediately
# end
#
# ruby_block 'create asterisk keys' do
#   block do
#     require 'ruby_expect'
#     Dir.chdir(File.join(File.dirname(tarball_path), "asterisk-#{node.asterisk.version}"))
#     exp = RubyExpect::Expect.spawn(%{./contrib/scripts/ast_tls_cert -C #{node.asterisk.host} -O "#{node.asterisk.box_name}" -d #{node.asterisk.keys_dir}}, debug: true)
#     exp.procedure do
#       each do
#         expect %r{Enter pass phrase for} do
#           send 'password'
#         end
#       end
#     end
#   end
#   action :nothing
# end

service "asterisk" do
  supports restart: true, reload: true, status: :true, debug: :true
  action :restart
end

include_recipe 'asterisk::config'
