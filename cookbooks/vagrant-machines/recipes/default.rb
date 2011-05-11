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
  mode 0750
  action :create
end

bash "initializing vagrant" do
  user "root"
  code %Q[/usr/local/rvm/bin/rvm-shell '1.9.2' -c 'vagrant init']
  not_if 'test -d $HOME/.vagrant'
end


node[:vagrant][:machines].each do |name, machine|
  bash "adding base box from #{machine[:url]}" do
    user "root"
    code %Q[/usr/local/rvm/bin/rvm-shell '1.9.2' -c "vagrant box add #{name} '#{machine[:url]}' || exit 0"]
  end

  #
  # Prefer to use the copy of chef we're already working with.
  #
  bash "copying chef repo to /storage/#{name}" do
    user "root"
    code "cp -vR /tmp/chef-solo /storage/#{name}"
    only_if "test -d /tmp/chef-solo"
  end

  git "/storage/#{name}" do
    user "root"
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
      :node_name => machine[:node_name],
      :forward_ssh_port => machine[:forward_ssh_port]
    )
  end

  bash "provisioning #{name}" do
    user "root"
    code %Q[
      cd /storage/#{name}
      /usr/local/rvm/bin/rvm-shell '1.9.2' -c "vagrant up; vagrant provision"
    ]
  end
end
