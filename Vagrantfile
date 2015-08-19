# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  # config.vm.network "forwarded_port", guest: 80, host: 8080
  # config.ssh.forward_agent = true
  # config.vm.synced_folder "../data", "/vagrant_data"

  config.vm.provider "virtualbox" do |vb|
    # Use VBoxManage to customize the VM. For example to change memory:
    #vb.customize ["modifyvm", :id, "--memory", "4096"]
  end

  config.vm.define :router do |router|
    router.vm.hostname = "router"
    router.vm.network "private_network", ip: "192.168.10.10", virtualbox__intnet: "net10"
    router.vm.network "private_network", ip: "192.168.20.10", virtualbox__intnet: "net20"
    router.vm.network "private_network", ip: "192.168.30.10", virtualbox__intnet: "net30"
  end

  config.vm.define :node101 do |node101|
    node101.vm.hostname = "node101"
    node101.vm.network "private_network", ip: "192.168.10.101", virtualbox__intnet: "net10"
  end

  config.vm.define :node201 do |node201|
    node201.vm.hostname = "node201"
    node201.vm.network "private_network", ip: "192.168.20.101", virtualbox__intnet: "net20"
  end

  config.vm.define :node301 do |node301|
    node301.vm.hostname = "node301"
    node301.vm.network "private_network", ip: "192.168.30.101", virtualbox__intnet: "net30"
  end

  config.vm.provision "puppet" do |puppet|
    puppet.module_path = "modules"
  end

end
