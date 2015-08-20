# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

def local_cache(box_name)
  cache_dir = File.join(File.dirname(__FILE__), '.vagrant_cache', 'apt', box_name)
  partial_dir = File.join(cache_dir, 'partial')
  FileUtils.mkdir_p(partial_dir) unless File.exists? partial_dir
  cache_dir
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  # config.vm.network "forwarded_port", guest: 80, host: 8080
  # config.ssh.forward_agent = true
  # config.vm.synced_folder "../data", "/vagrant_data"

  router_ram = "256"
  cassandra_ram = "768"

  cache_dir = local_cache(config.vm.box)
  config.vm.synced_folder cache_dir, "/var/cache/apt/archives/"

  config.vm.define :router12 do |router12|
    router12.vm.provider "virtualbox" do |vb|
      vb.memory = router_ram
    end
    router12.vm.hostname = "router12"
    # net1 (eth1)
    router12.vm.network "private_network", ip: "10.1.1.2", virtualbox__intnet: "net1"
    # net2 (eth2)
    router12.vm.network "private_network", ip: "10.1.2.1", virtualbox__intnet: "net2"
  end

  config.vm.define :router23 do |router23|
    router23.vm.provider "virtualbox" do |vb|
      vb.memory = router_ram
    end
    router23.vm.hostname = "router23"
    # net2 (eth1)
    router23.vm.network "private_network", ip: "10.1.2.3", virtualbox__intnet: "net2"
    # net3 (eth2)
    router23.vm.network "private_network", ip: "10.1.3.2", virtualbox__intnet: "net3"
  end

  config.vm.define :router13 do |router13|
    router13.vm.provider "virtualbox" do |vb|
      vb.memory = router_ram
    end
    router13.vm.hostname = "router13"
    # net1 (eth1)
    router13.vm.network "private_network", ip: "10.1.1.3", virtualbox__intnet: "net1"
    # net3 (eth2)
    router13.vm.network "private_network", ip: "10.1.3.1", virtualbox__intnet: "net3"
  end

  config.vm.define :node101 do |node101|
    node101.vm.provider "virtualbox" do |vb|
      vb.memory = cassandra_ram
    end
    node101.vm.hostname = "node101"
    node101.vm.network "private_network", ip: "10.1.1.101", virtualbox__intnet: "net1"
  end

  config.vm.define :node102 do |node102|
    node102.vm.provider "virtualbox" do |vb|
      vb.memory = cassandra_ram
    end
    node102.vm.hostname = "node102"
    node102.vm.network "private_network", ip: "10.1.1.102", virtualbox__intnet: "net1"
  end

  config.vm.define :node201 do |node201|
    node201.vm.provider "virtualbox" do |vb|
      vb.memory = cassandra_ram
    end
    node201.vm.hostname = "node201"
    node201.vm.network "private_network", ip: "10.1.2.101", virtualbox__intnet: "net2"
  end

  config.vm.define :node202 do |node202|
    node202.vm.provider "virtualbox" do |vb|
      vb.memory = cassandra_ram
    end
    node202.vm.hostname = "node202"
    node202.vm.network "private_network", ip: "10.1.2.102", virtualbox__intnet: "net2"
  end

  config.vm.define :node301 do |node301|
    node301.vm.provider "virtualbox" do |vb|
      vb.memory = cassandra_ram
    end
    node301.vm.hostname = "node301"
    node301.vm.network "private_network", ip: "10.1.3.101", virtualbox__intnet: "net3"
  end

  config.vm.define :node302 do |node302|
    node302.vm.provider "virtualbox" do |vb|
      vb.memory = cassandra_ram
    end
    node302.vm.hostname = "node301"
    node302.vm.network "private_network", ip: "10.1.3.102", virtualbox__intnet: "net3"
  end

  config.vm.provision "puppet" do |puppet|
    puppet.module_path = "modules"
  end

end
