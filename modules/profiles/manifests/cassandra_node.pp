class profiles::cassandra_node {
  class { 'cassandra':
    cluster_name      => 'vagrantCluster',
    package_name      => 'dsc21',
    seeds             => [ '10.1.1.101', '10.1.2.101', '10.1.3.101' ],
    version           => '2.1.8-1',
    endpoint_snitch   => 'GossipingPropertyFileSnitch',
    listen_address    => $::ipaddress_eth1,
    broadcast_address => $::ipaddress_eth1,
    rpc_address       => $::ipaddress_eth1,
    rpc_max_threads   => '128',
    max_heap_size     => '128M',
    heap_newsize      => '16M',
  }

  # Fix for packaging bug that references the incorrect jar
  file { '/usr/share/cassandra/lib/jamm-0.2.8.jar':
    ensure  => link,
    target  => '/usr/share/cassandra/lib/jamm-0.3.0.jar',
    notify  => Service['cassandra'],
    require => Package['cassandra'],
  }

  $octets = split($::ipaddress_eth1, '[.]')
  $datacenter = "DC${octets[2]}"
  $rack = "R${octets[3]}"
  file { '/etc/cassandra/cassandra-rackdc.properties':
    ensure  => file,
    content => "dc=${datacenter}\nrack=${rack}\nprefer_local=true",
    notify  => Service['cassandra'],
    require => Package['cassandra'],
  }

  Package['dsc21'] -> File['/usr/share/cassandra/lib/jamm-0.2.8.jar']
}
