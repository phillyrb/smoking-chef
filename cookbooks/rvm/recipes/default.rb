#
# Cookbook Name:: rvm
# Recipe:: default

# Make sure that the package list is up to date on Ubuntu/Debian.
include_recipe "apt" if [ 'debian', 'ubuntu' ].member? node[:platform]

# Make sure we have all we need to compile ruby implementations:
package "curl"
package "git-core"
include_recipe "build-essential"
 
%w(libreadline5-dev zlib1g-dev libssl-dev libxml2-dev libxslt1-dev).each do |pkg|
  package pkg
end

bash "fixing ubuntu system-wide bashrc" do
  user "root"
  code %q[grep -v '[ -z "$PS1" ] && return' /etc/bash.bashrc >/tmp/bash.bashrc && cp /tmp/bash.bashrc /etc/bash.bashrc]
end

bash "installing system-wide RVM stable" do
  user "root"
  code "bash < <( curl -s https://rvm.beginrescueend.com/install/rvm )" 
  not_if "test -d /usr/local/rvm"
end

bash "upgrading to RVM head" do
  user "root"
  code "/usr/local/rvm/bin/rvm update --head ; /usr/local/rvm/bin/rvm reload"
  only_if { node[:rvm][:version] == :head }
  only_if { node[:rvm][:track_updates] }
end

bash "upgrading RVM stable" do
  user "root"
  code "/usr/local/rvm/bin/rvm update ; /usr/local/rvm/bin/rvm reload"
  only_if { node[:rvm][:track_updates] }
end

cookbook_file "/usr/local/bin/rvm-gem.sh" do
  owner "root"
  group "root"
  mode 0755
end
