cookbook_file "~vagrant/.gemrc" do
  source "gemrc"
  owner "vagrant"
  group "vagrant"
  mode 0644
end
