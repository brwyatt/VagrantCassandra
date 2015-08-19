class profiles::environments::net3 {
  network_route { 'net1':
    network => '10.1.1.0',
    gateway => '10.1.3.1',
    iface   => 'eth1',
  }
  network_route { 'net2':
    network => '10.1.2.0',
    gateway => '10.1.3.2',
    iface   => 'eth1',
  }
}
