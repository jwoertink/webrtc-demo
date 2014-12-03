source_path = '/usr/local/src'
version = '1.4.15'
source_url_prefix = 'http://downloads.asterisk.org/pub/telephony/libpri/'
tarball = "libpri-#{version}.tar.gz"
tarball_url = source_url_prefix + tarball
tarball_source_path = source_path + tarball

remote_file tarball_source_path do
  source tarball_url
  backup false
  action :create
end

bash 'install libpri' do
  user 'root'
  cwd File.dirname(tarball_source_path)
  code <<-EOH
    tar zxf #{tarball_source_path}
    cd libpri*
    make
    make install
  EOH
end
