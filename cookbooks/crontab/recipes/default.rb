cookbook_file '/etc/crontab' do
  owner 'root'
  group 'root'
  action :create
  source 'crontab'
end
