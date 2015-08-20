class profiles::cassandra_node {
  class { 'cassandra':
    cluster_name      => 'vagrantCluster',
    package_name      => 'dsc21',
    seeds             => [ '10.1.1.101', '10.1.2.101', '10.1.3.101' ],
    version           => '2.1.8-1',
    listen_address    => $::ipaddress_eth1,
    broadcast_address => $::ipaddress_eth1,
    rpc_address       => $::ipaddress_eth1,
    rpc_max_threads   => '128',
    max_heap_size     => '128M',
    heap_newsize      => '16M',
  }
  file { '/usr/share/cassandra/lib/jamm-0.2.8.jar':
    ensure => link,
    target => '/usr/share/cassandra/lib/jamm-0.3.0.jar',
    notify => Service['cassandra'],
  }

  Package['dsc21'] -> File['/usr/share/cassandra/lib/jamm-0.2.8.jar']
}
