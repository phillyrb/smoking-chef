include_recipe "gt-services::default"

bash "copy gem-shipper code into /root" do
  user "root"
  code "cp /tmp/chef-solo/services/gem-shipper /root && chmod 750 /root/gem-shipper"
end

template "/storage/machines/machine_ports" do
  owner "root"
  group "root"
  mode 0640
  source "machine_ports.erb" 
  variables(:machines => node[:vagrant][:machines].map { |x| x[1] }) 
end
