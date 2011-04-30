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

install_gem 'sqlite3'

bash 'copying gem-sniffer code' do
  user 'root'
  code 'cp -R /test/smoking-chef/services/gem-sniffer /root/gem-sniffer && chmod a+x /root/gem-sniffer'
end
