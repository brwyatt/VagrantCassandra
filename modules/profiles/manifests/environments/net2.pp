class profiles::environments::net2 {
  network_route { 'net1':
    network => '10.1.1.0',
    gateway => '10.1.2.1',
    iface   => 'eth1',
  }
  network_route { 'net3':
    network => '10.1.3.0',
    gateway => '10.1.2.3',
    iface   => 'eth1',
  }
}
