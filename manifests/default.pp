node 'router' {
  include ::profiles::router
}

node /node1[0-9]{2}/ {
  include ::profiles::environments::net10
}

node /node2[0-9]{2}/ {
  include ::profiles::environments::net20
}

node /node3[0-9]{2}/ {
  include ::profiles::environments::net30
}

define network_route (
  $network,
  $gateway,
  $netmask = '255.255.255.0',
  $iface = 'eth0',
) {
  exec { $title:
    path    => '/sbin:/bin',
    command => "bash -c 'route add -net ${network} netmask ${netmask} gw ${gateway} dev ${iface}'",
    unless  => "bash -c 'route|grep -E \\\'^${network} +${gateway} +${netmask} +UG +0 +0 +0 +${iface}\$\\\\''"
  }
}
