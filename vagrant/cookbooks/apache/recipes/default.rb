package 'httpd'

service 'httpd' do
  supports restart: true
  action [:start, :enable]
end

template '/var/www/html/index.html' do
  source 'index.html.erb'
end
