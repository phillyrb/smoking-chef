apt_repository "virtualbox" do
  uri "http://download.virtualbox.org/virtualbox/debian"
  distribution "maverick"
  components ["contrib"]
  action :add
end

execute "wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -"
execute "apt-get update"

package "virtualbox-4.0" do
  action :install
end
