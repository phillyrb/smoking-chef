include_recipe "gt-services::default"

bash 'copying gem-sniffer code' do
  user 'root'
  code 'cp -R /test/smoking-chef/services/gem-sniffer /root/gem-sniffer && chmod a+x /root/gem-sniffer'
end
