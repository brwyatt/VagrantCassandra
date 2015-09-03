class profiles::opscenter {

  $seed_nodes = hiera('cassandra::seeds', [])

  class { 'cassandra::repo':
    repo_name => 'datastax',
    baseurl   => 'http://debian.datastax.com/community',
    key_id    => 'B999A372',
    gpgkey    => 'http://debian.datastax.com/debian/repo_key',
    repos     => 'main',
    release   => 'stable',
    pin       => '200',
    gpgcheck  => '0',
    enabled   => '1',
  } ->
  package { 'opscenter':
    ensure => installed,
  } ->
  file { '/etc/opscenter/clusters':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  } ->
  file { '/etc/opscenter/clusters/vagrantCluster.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('profiles/opscenter/vagrantCluster.conf.erb'),
    notify  => Service['opscenterd'],
  } ->
  service { 'opscenterd':
    ensure => running,
  }
}
