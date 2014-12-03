# PJProject has issues installing on a 64bit machine.
# This hack fixes that.
Chef::Resource::Bash.class_eval do
  def hack_pjproject
    %{
      cd /usr/lib64/lib
      mv -f lib* ..
      mv -f pkgconfig/libpjproject.pc ../pkgconfig/
      cd /usr/local/src/pjproject*
    }
  end
end

source_path = '/usr/local/src/'
version = '2.3'
source_url_prefix = "http://www.pjsip.org/release/#{version}/"
tarball = "pjproject-#{version}.tar.bz2"
tarball_url = source_url_prefix + tarball
tarball_source_path = source_path + tarball

remote_file tarball_source_path do
  source tarball_url
  backup false
  action :create
end

bash 'install pjproject' do
  user 'root'
  cwd File.dirname(tarball_source_path)
  code <<-EOH
    tar -xjvf #{tarball}
    cd pjproject*
    ./configure --prefix=/usr/lib64/ --enable-shared
    make dep
    make
    make install
    #{hack_pjproject}
    ldconfig
  EOH
end

# TODO: Should we check ldconfig count? It should be more that 0
# ldconfig -p | grep pj | wc -l
