class profiles::router {
  include ::firewall

  firewall { '000 forward eth1 to eth2':
    chain    => 'FORWARD',
    iniface  => 'eth1',
    outiface => 'eth2',
    action   => 'accept',
  }
  firewall { '000 forward eth2 to eth1':
    chain    => 'FORWARD',
    iniface  => 'eth2',
    outiface => 'eth1',
    action   => 'accept',
  }

  #enable forwarding
  sysctl { 'net.ipv4.ip_forward':
    value => '1',
  }
}
