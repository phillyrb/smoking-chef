include_recipe "gt-services::default"

#
# refactor into a lib
#

def install_gem gem 
  gem_package gem do
    gem_binary "/usr/local/bin/rvm-gem.sh"
  end
end

bash 'copying gem-sniffer code' do
  user 'root'
  code 'cp -R /test/smoking-chef/services/gem-sniffer /root/gem-sniffer && chmod a+x /root/gem-sniffer'
end
