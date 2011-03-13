$:.unshift '.'
require 'spatula'

Vagrant::Config.run do |config|
  config.vm.box = "ubuntu"
  config.vm.provision SpatulaProvisioner do |spatula|
    spatula.node = "bootstrap"
  end
end
