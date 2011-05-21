#
# refactor into a lib
#

def install_gem gem, ver=nil
  gem_package gem do
    version ver 
    gem_binary "/usr/local/bin/rvm-gem.sh"
  end
end

install_gem 'spatula'
install_gem 'virtualbox', '0.8.3'
install_gem 'vagrant', '0.7.3'
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

bash "configure vagrant for startup" do
  user "root"
  code "update-rc.d start 21 stop 19"
  not_if 'test -e /etc/rc2.d/S21vagrant'
end
