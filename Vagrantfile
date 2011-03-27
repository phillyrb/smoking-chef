require 'vagrant/spatula'

Vagrant::Config.run do |config|
  config.vm.box = "ubuntu"
  config.vm.provision SpatulaProvisioner do |spatula|
    spatula.node = "bootstrap"
  end

  config.vm.customize do |custom|
    custom.memory_size = 4096
  end
end
