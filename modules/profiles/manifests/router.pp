class profiles::router {
  include ::firewall

  #net10 (eth1)
  firewall { '000 forward net10 to net20':
    chain    => 'FORWARD',
    iniface  => 'eth1',
    outiface => 'eth2',
    action   => 'accept',
  }
  firewall { '000 forward net10 to net30':
    chain    => 'FORWARD',
    iniface  => 'eth1',
    outiface => 'eth3',
    action   => 'accept',
  }

  #net20 (eth2)
  firewall { '000 forward net20 to net10':
    chain    => 'FORWARD',
    iniface  => 'eth2',
    outiface => 'eth1',
    action   => 'accept',
  }
  firewall { '000 forward net20 to net30':
    chain    => 'FORWARD',
    iniface  => 'eth2',
    outiface => 'eth3',
    action   => 'accept',
  }

  #net30 (eth3)
  firewall { '000 forward net30 to net10':
    chain    => 'FORWARD',
    iniface  => 'eth3',
    outiface => 'eth1',
    action   => 'accept',
  }
  firewall { '000 forward net30 to net20':
    chain    => 'FORWARD',
    iniface  => 'eth3',
    outiface => 'eth2',
    action   => 'accept',
  }

  #enable forwarding
  sysctl { 'net.ipv4.ip_forward':
    value => '1',
  }
}
