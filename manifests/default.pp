stage { 'network':
  before => Stage['main'],
}

# Routers
node /router-[0-9]-[0-9]/ {
  include ::profiles::router
}

# Cassandra nodes
node /cassandra-[0-9]-[0-9]/ {
  include ::profiles::cassandra_node
  include ::profiles::vagrant_network
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
