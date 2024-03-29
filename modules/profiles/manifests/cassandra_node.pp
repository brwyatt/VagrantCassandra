class profiles::cassandra_node {

  $octets = split($::ipaddress_eth1, '[.]')
  $datacenter = "DC${octets[2]}"
  $rack = "R${octets[3]}"
  $opscenter = "${octets[0]}.${octets[1]}.${octets[2]}.25"

  class { 'cassandra':
    cluster_name          => 'VagrantCluster',
    package_name          => 'dsc21',
    version               => '2.1.8-1',
    endpoint_snitch       => 'GossipingPropertyFileSnitch',
    dc                    => $datacenter,
    rack                  => $rack,
    listen_address        => $::ipaddress_eth1,
    broadcast_address     => $::ipaddress_eth1,
    rpc_address           => '0.0.0.0',
    rpc_broadcast_address => $::ipaddress_eth1,
    rpc_max_threads       => '64',
    max_heap_size         => '64M',
    heap_newsize          => '16M',
  }

  # Fix for packaging bug that references the incorrect jar
  file { '/usr/share/cassandra/lib/jamm-0.2.8.jar':
    ensure  => link,
    target  => '/usr/share/cassandra/lib/jamm-0.3.0.jar',
    notify  => Service['cassandra'],
    require => Package['dsc21'],
  }

  Package['dsc21'] -> File['/usr/share/cassandra/lib/jamm-0.2.8.jar']

  package { 'datastax-agent':
    ensure  => installed,
    require => Class['cassandra'],
  } ->
  file { '/var/lib/datastax-agent/conf/address.yaml':
    ensure  => file,
    owner   => 'cassandra',
    group   => 'cassandra',
    mode    => '0640',
    content => "stomp_interface: ${opscenter}\nuse_ssl: 0",
    notify  => Service['datastax-agent'],
  } ->
  service { 'datastax-agent':
    ensure    => running,
    subscribe => Service['cassandra'],
  }
}
