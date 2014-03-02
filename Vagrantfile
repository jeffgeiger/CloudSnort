# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

config.vm.define :sensor do |sensor|
  sensor.vm.box = "precise64"
  sensor.vm.hostname = "sensor"
  sensor.vm.network :private_network, ip: "192.168.0.3"
  sensor.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file  = "base.pp"
    puppet.module_path = "puppet/modules"
  end
end

config.vm.define :cloudclient1 do |cloudclient1|
  cloudclient1.vm.box = "precise64"
  cloudclient1.vm.hostname = "cloudclient1"
  cloudclient1.vm.network :private_network, ip: "192.168.0.4"
  cloudclient1.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file  = "base.pp"
    puppet.module_path = "puppet/modules"
  end
end

config.vm.define :cloudclient2 do |cloudclient2|
  cloudclient2.vm.box = "precise64"
  cloudclient2.vm.hostname = "cloudclient2"
  cloudclient2.vm.network :private_network, ip: "192.168.0.5"
  cloudclient2.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file  = "base.pp"
    puppet.module_path = "puppet/modules"
  end
end

end
