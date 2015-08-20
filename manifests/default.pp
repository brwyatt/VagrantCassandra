node /router[0-9]{2}/ {
  include ::profiles::router
}

# Datacenter 1
node /node1[0-9]{2}/ {
  include ::profiles::environments::net1
  include ::profiles::cassandra_node
}

# Datacenter 2
node /node2[0-9]{2}/ {
  include ::profiles::environments::net2
  include ::profiles::cassandra_node
}

# Datacenter 3
node /node3[0-9]{2}/ {
  include ::profiles::environments::net3
  include ::profiles::cassandra_node
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
