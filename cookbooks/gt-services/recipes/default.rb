group 'test' do
  action :create
end

user 'test' do
  shell '/bin/bash'
  home '/test'
  group 'test'
  action :create
end

directory '/test' do
  owner 'test'
  group 'test'
  mode '0755'
  action :create
end

git '/test/smoking-chef' do
  user 'test'
  group 'test'
  repository 'git://github.com/phillyrb/smoking-chef.git'
  reference 'master'
  action :sync
end
