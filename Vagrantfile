require 'vagrant/spatula'

Vagrant::Config.run do |config|
  config.vm.box = "ubuntu"
  config.vm.provision SpatulaProvisioner do |spatula|
    spatula.node = "bootstrap"
  end

  config.vm.customize do |vm|
    vm.memory_size = 3500 
    vm.cpu_count = 2
  end
end
