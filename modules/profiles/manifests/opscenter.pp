class profiles::opscenter {
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
  service { 'opscenterd':
    ensure => running,
  }
}
