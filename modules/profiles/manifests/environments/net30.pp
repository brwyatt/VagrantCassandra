class profiles::environments::net30 {
  network_route { 'net10':
    network => '10.1.10.0',
    gateway => '10.1.30.10',
    iface   => 'eth1',
  }
  network_route { 'net20':
    network => '10.1.20.0',
    gateway => '10.1.30.10',
    iface   => 'eth1',
  }
}
