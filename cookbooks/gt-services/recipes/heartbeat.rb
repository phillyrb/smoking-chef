include_recipe "gt-services::default"

#
# refactor into a lib
#

def install_gem gem 
  gem_package gem do
    gem_binary "/usr/local/bin/rvm-gem.sh"
  end
end

%w[sqlite3 libsqlite3-dev].each do |pkg|
  package pkg do
    action :install
  end
end

install_gem 'thin'
install_gem 'sinatra'
install_gem 'sqlite3-ruby'

cookbook_file '/etc/init.d/heartbeat' do
  action :create
  owner 'root'
  group 'root'
  mode '0755'
  source 'heartbeat'
end

directory '/test/heartbeat' do
  owner 'test'
  group 'test'
  mode '0755'
  action :create
end

bash 'copying heartbeat code' do
  user 'test'
  code 'cp -R /test/smoking-chef/services/heartbeat/* /test/heartbeat'
end

bash 'initializing database for heartbeat daemon' do
  user 'test'
  code 'cd /test/heartbeat && ruby init_heartbeat.rb' 
  not_if 'test -f /test/heartbeat/heartbeat.db'
end

service 'heartbeat' do
  action [:enable, :restart]
  supports :restart => true
  enabled true
end
