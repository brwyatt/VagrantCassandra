class profiles::environments::net20 {
  network_route { 'net10':
    network => '10.1.10.0',
    gateway => '10.1.20.10',
    iface   => 'eth1',
  }
  network_route { 'net30':
    network => '10.1.30.0',
    gateway => '10.1.20.10',
    iface   => 'eth1',
  }
}
