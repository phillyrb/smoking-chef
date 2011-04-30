def install_gem gem 
  gem_package gem do
    gem_binary "/usr/local/bin/rvm-gem.sh"
  end
end

package "git-core" do
  action :install
end

install_gem "hoe"

git "/tmp/rubygems-mirror" do
  repository "git://github.com/rubygems/rubygems-mirror.git"
  action :sync
end

bash "building and installing rubygems-mirror" do
  cwd "/tmp/rubygems-mirror"
  code "/usr/local/bin/rvm-shell '1.9.2' -c 'rake gem && gem install pkg/rubygems-mirror*.gem'"
  not_if "gem list --local | grep -q 'rubygems-mirror'"
end

directory "/tmp/rubygems-mirror" do
  action :delete
  recursive true
end

directory "/storage/rubygems-mirror" do
  action :create
  recursive true
end

cookbook_file '/root/.gemmirrorrc' do
  action :create
  owner 'root'
  group 'root'
  source 'gemmirrorrc'
end
