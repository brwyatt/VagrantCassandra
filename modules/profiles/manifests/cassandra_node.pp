class profiles::cassandra_node {
  class { 'cassandra':
    cluster_name => 'vagrantCluster',
    package_name => 'dsc21',
    seeds        => [ '10.1.1.101', '10.1.2.101', '10.1.3.101' ],
    version      => '2.1.8-1',
  }
}
