def install_gem gem 
  gem_package gem do
    gem_binary "/usr/local/bin/rvm-gem.sh"
  end
end

node[:rvm_gems].each { |gem| install_gem gem } 
