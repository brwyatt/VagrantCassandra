class profiles::environments::net1 {
  network_route { 'net2':
    network => '10.1.2.0',
    gateway => '10.1.1.2',
    iface   => 'eth1',
  }
  network_route { 'net3':
    network => '10.1.3.0',
    gateway => '10.1.1.3',
    iface   => 'eth1',
  }
}
