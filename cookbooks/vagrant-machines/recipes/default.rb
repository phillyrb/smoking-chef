#
# refactor into a lib
#

def install_gem gem 
  gem_package gem do
    gem_binary "/usr/local/bin/rvm-gem.sh"
  end
end

install_gem 'spatula'
install_gem 'vagrant'
install_gem 'vagrant-spatula'

directory '/storage' do
  owner 'root'
  group 'root'
  mode 750
  action :create
end

node[:vagrant][:machines].each do |name, machine|
  bash "adding base box from #{machine[:url]}" do
    code %Q[rvm-shell '1.9.2' -c "vagrant box add #{name} '#{machine[:url]}'" || exit 0]
  end

  #
  # Prefer to use the copy of chef we're already working with.
  #
  bash "copying chef repo to /storage/#{name}" do
    code "cp -vR /tmp/chef-solo /storage/#{name}"
    only_if "test -d /tmp/chef-solo"
  end

  git "/storage/#{name}" do
    repository "git://github.com/phillyrb/smoking-chef" 
    not_if "test -d /tmp/chef-solo"
  end

  template "/storage/#{name}/Vagrantfile" do
    source "Vagrantfile.erb"
    mode 0640
    owner 'root'
    group 'root'
    variables(
      :box_name => name,
      :machine_memory => machine[:memory],
      :node_name => machine[:node_name]
    )
  end

  bash "provisioning #{name}" do
    code "cd /storage/#{name}; rvm-shell '1.9.2' -c 'vagrant init; (vagrant up || vagrant provision) 2>&1 1>/tmp/provision-#{name}-log'"
  end
end
