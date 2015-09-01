# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

network_ip_prefix = "10.1"
network_name_prefix = "net"
network_count = 3
max_nodes_per_datacenter = 3

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

  # Configure Cassandra nodes
  (0..last_network).each do |net|
    (1..max_nodes_per_datacenter).each do |num|
      nodename = "cassandra-#{net}-#{num}"
      if num == 1
        # Only autostart if the first node
        auto = true
      else
        auto = false
      end
      config.vm.define nodename, autostart: auto do |node|
        node.vm.provider "virtualbox" do |vb|
          vb.memory = "768"
        end
        node.vm.hostname = nodename
        if num == 1
          node.vm.network "private_network", ip: "#{network_ip_prefix}.#{net}.50", virtualbox__intnet: "#{network_name_prefix}#{net}"
        else
          node.vm.network "private_network", type: "dhcp", virtualbox__intnet: "#{network_name_prefix}#{net}"
        end
      end
    end
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
