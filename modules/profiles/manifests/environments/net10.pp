class profiles::environments::net10 {
  network_route { 'net20':
    network => '10.1.20.0',
    gateway => '10.1.10.10',
    iface   => 'eth1',
  }
  network_route { 'net30':
    network => '10.1.30.0',
    gateway => '10.1.10.10',
    iface   => 'eth1',
  }
}
