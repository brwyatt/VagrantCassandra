class profiles::vagrant_network (
  $networkprefix = '10.1',
  $networks = [ 0 ],
){

  $octets = split($::ipaddress_eth1, '[.]')
  $mynetwork = $octets[2]

  define loop_networks ($mynetwork = 0, $network = $title) {
    if $network != $mynetwork {
      network_route { "net${network}":
        network => "10.1.${network}.0",
        gateway => "10.1.${mynetwork}.${network}",
        iface   => 'eth1',
      }
    }
  }
  loop_networks { $networks:
    mynetwork => $mynetwork,
  }
}
