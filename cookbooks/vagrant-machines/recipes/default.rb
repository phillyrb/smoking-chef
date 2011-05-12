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

directory '/storage/machines' do
  owner 'root'
  group 'root'
  mode 0750
  action :create
end

node[:vagrant][:machines].each do |name, machine|
  bash "adding base box from #{machine[:url]}" do
    user "root"
    code %Q[/usr/local/rvm/bin/rvm-shell '1.9.2' -c "vagrant box add #{name} '#{machine[:url]}' || exit 0"]
  end

  #
  # Prefer to use the copy of chef we're already working with.
  #
  bash "copying chef repo to /storage/machines/#{name}" do
    user "root"
    code "cp -vR /tmp/chef-solo /storage/machines/#{name}"
    only_if "test -d /tmp/chef-solo"
  end

  git "/storage/machines/#{name}" do
    user "root"
    repository "git://github.com/phillyrb/smoking-chef" 
    not_if "test -d /tmp/chef-solo"
  end

  template "/storage/machines/#{name}/Vagrantfile" do
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

  bash "provisioning/starting #{name}" do
    user "root"
    code %Q[
      cd /storage/machines/#{name}
      /usr/local/rvm/bin/rvm-shell '1.9.2' -c "vagrant up; vagrant provision"
    ]
  end
end

cookbook_file "/etc/init.d/vagrant" do
  source "vagrant_rc.d"
  owner "root"
  group "root"
  mode 0750
end

service 'vagrant' do
  action [:enable, :restart]
  supports :restart => true
  enabled true
end

#
# FIXME
#
# Really not happy about this, there has to be some way to do this in the init
# settings.
#
bash "move vagrant run order" do
  code "mv /etc/rc2.d/S20vagrant /etc/rc2.d/S21vagrant && mv /etc/rc6.d/K20vagrant /etc/rc6.d/K19vagrant"
  not_if "test -f /etc/rc2.d/S21vagrant"
end
