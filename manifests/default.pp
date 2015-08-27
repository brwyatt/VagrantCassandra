stage { 'network':
  before => Stage['main'],
}

node /router[0-9]{2}/ {
  include ::profiles::router
}

# Datacenter 1
node /node1[0-9]{2}/ {
  class { '::profiles::environments::net1':
    stage => network,
  }
  include ::profiles::cassandra_node
}

# Datacenter 2
node /node2[0-9]{2}/ {
  class { '::profiles::environments::net2':
    stage => network,
  }
  include ::profiles::cassandra_node
}

# Datacenter 3
node /node3[0-9]{2}/ {
  class { '::profiles::environments::net3':
    stage => network,
  }
  include ::profiles::cassandra_node
}

# OpsCenter
node "opscenter" {
  include ::profiles::opscenter
}

define network_route (
  $network,
  $gateway,
  $netmask = '255.255.255.0',
  $iface = 'eth0',
) {
  exec { $title:
    path    => '/sbin:/bin',
    command => "bash -c 'route add -net ${network} netmask ${netmask} gw ${gateway} dev ${iface}'",
    unless  => "bash -c 'route|grep -E \\\'^${network} +${gateway} +${netmask} +UG +0 +0 +0 +${iface}\$\\\\''"
  }
}

service { 'chef-client':
  ensure => stopped,
}

file { '/home/vagrant/.hushlogin':
  ensure => file,
  owner  => 'vagrant',
  group  => 'vagrant',
  mode   => '0770',
}
