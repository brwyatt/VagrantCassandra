# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

network_ip_prefix = "10.1"
network_name_prefix = "net"
network_count = 3

last_network = network_count-1

# Setup DHCP
if ARGV[0] == 'up'
  (0..last_network).each do |network|
    system("
      echo 'Creating DHCP server for #{network_name_prefix}#{network}...'
      VBoxManage dhcpserver add\
      --netname #{network_name_prefix}#{network}\
      --ip #{network_ip_prefix}.#{network}.254\
      --netmask 255.255.255.0\
      --lowerip #{network_ip_prefix}.#{network}.100\
      --upperip #{network_ip_prefix}.#{network}.250\
      --enable\
      || true
    ")
  end
end

# Create local caching for packages
def local_cache(box_name)
  cache_dir = File.join(File.dirname(__FILE__), '.vagrant_cache', 'apt', box_name)
  partial_dir = File.join(cache_dir, 'partial')
  FileUtils.mkdir_p(partial_dir) unless File.exists? partial_dir
  cache_dir
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  cassandra_ram = "768"

  cache_dir = local_cache(config.vm.box)
  config.vm.synced_folder cache_dir, "/var/cache/apt/archives/"

  # Configure routers
  (0..(last_network-1)).each do |net1|
    ((net1+1)..last_network).each do |net2|
      routername = "router-#{net1}-#{net2}"
      config.vm.define routername do |router|
        router.vm.privider "virtualbox" do |vb|
          vb.memory = "256"
        end
        router.vm.hostname = routername
        router.vm.network "private_network", ip: "#{network_ip_prefix}.#{net1}.#{net2}", virtualbox__intnet: "#{network_name_prefix}#{net1}"
        router.vm.network "private_network", ip: "#{network_ip_prefix}.#{net2}.#{net1}", virtualbox__intnet: "#{network_name_prefix}#{net2}"
      end
    end
  end

  config.vm.define :node101 do |node101|
    node101.vm.provider "virtualbox" do |vb|
      vb.memory = cassandra_ram
    end
    node101.vm.hostname = "node101"
    node101.vm.network "private_network", ip: "10.1.1.101", virtualbox__intnet: "net1"
  end

  config.vm.define :node102, autostart: false do |node102|
    node102.vm.provider "virtualbox" do |vb|
      vb.memory = cassandra_ram
    end
    node102.vm.hostname = "node102"
    node102.vm.network "private_network", type: "dhcp", virtualbox__intnet: "net1"
  end

  config.vm.define :node103, autostart: false do |node103|
    node103.vm.provider "virtualbox" do |vb|
      vb.memory = cassandra_ram
    end
    node103.vm.hostname = "node103"
    node103.vm.network "private_network", type: "dhcp", virtualbox__intnet: "net1"
  end

  config.vm.define :node201 do |node201|
    node201.vm.provider "virtualbox" do |vb|
      vb.memory = cassandra_ram
    end
    node201.vm.hostname = "node201"
    node201.vm.network "private_network", ip: "10.1.2.101", virtualbox__intnet: "net2"
  end

  config.vm.define :node202, autostart: false do |node202|
    node202.vm.provider "virtualbox" do |vb|
      vb.memory = cassandra_ram
    end
    node202.vm.hostname = "node202"
    node202.vm.network "private_network", type: "dhcp", virtualbox__intnet: "net2"
  end

  config.vm.define :node203, autostart: false do |node203|
    node203.vm.provider "virtualbox" do |vb|
      vb.memory = cassandra_ram
    end
    node203.vm.hostname = "node203"
    node203.vm.network "private_network", type: "dhcp", virtualbox__intnet: "net2"
  end

  config.vm.define :node301 do |node301|
    node301.vm.provider "virtualbox" do |vb|
      vb.memory = cassandra_ram
    end
    node301.vm.hostname = "node301"
    node301.vm.network "private_network", ip: "10.1.3.101", virtualbox__intnet: "net3"
  end

  config.vm.define :node302, autostart: false do |node302|
    node302.vm.provider "virtualbox" do |vb|
      vb.memory = cassandra_ram
    end
    node302.vm.hostname = "node302"
    node302.vm.network "private_network", type: "dhcp", virtualbox__intnet: "net3"
  end

  config.vm.define :node303, autostart: false do |node303|
    node303.vm.provider "virtualbox" do |vb|
      vb.memory = cassandra_ram
    end
    node303.vm.hostname = "node303"
    node303.vm.network "private_network", type: "dhcp", virtualbox__intnet: "net3"
  end

  config.vm.define :opscenter, autostart: false do |opscenter|
    opscenter.vm.provider "virtualbox" do |vb|
      vb.memory = 512
    end
    opscenter.vm.network "forwarded_port", guest: 8888, host: 8888
    opscenter.vm.hostname = "opscenter"
    # net1 (eth1)
    opscenter.vm.network "private_network", ip: "10.1.1.10", virtualbox__intnet: "net1"
    # net2 (eth2)
    opscenter.vm.network "private_network", ip: "10.1.2.10", virtualbox__intnet: "net2"
    # net3 (eth2)
    opscenter.vm.network "private_network", ip: "10.1.3.10", virtualbox__intnet: "net3"
  end

  config.vm.provision "puppet" do |puppet|
    puppet.module_path = "modules"
  end

end
