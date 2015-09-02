Vagrant Cassandra
=================

Spinup a local, simulated, three-DataCenter deploy of Cassandra (with optional OpsCenter)

Requirements
------------

* Vagrant 1.6
* VirtualBox 4.x

Network Configuration
---------------------

Three networks are configured in VirtualBox by Vagrant and are used by various nodes.

* Public Network NAT - Provides access to the Internet and host machine. Defaults to 10.0.2.0/24.
* net1 - DataCenter 1. 10.1.1.0/24 with DHCP in 10.1.1.100-10.1.1.250
* net2 - DataCenter 2. 10.1.2.0/24 with DHCP in 10.1.2.100-10.1.2.250
* net3 - DataCenter 3. 10.1.3.0/24 with DHCP in 10.1.3.100-10.1.3.250

Server Configurations
---------------------

All servers are configured using the Vagrant box `ubuntu/trusty64` with 1 CPU and eth0 will be the Public Network NAT interface and default gateway. Further network interfaces will be configured for inter-node communications; the public interface is only used by `apt-get` and for communications with the host (such as `vagrant ssh` or forwarded ports).

All configurations are created in Puppet, and can be found in `./manifests/default.pp` or under `./modules/`. Puppet installs and configures software on the servers, in addition to configuring the network routes needed to ensure proper traffic flow between the virtual networks.

### Routers

Routers are the bridges between the virtual networks. They are configured with 256MB of RAM and two additional network interfaces. The numbers at the end of the name represent the networks they bridge (so "router-1-2" bridges network 1 and 2). The network interfaces are configured such that eth1 will be on the lower-numbered network and eth2 will be on the higher-numbered network. The last octet of the static IPs represent the network it routes to (so, in the case of "router-1-2", eth1 is connected to net1 with an IP of 10.1.1.2, and eth2 is connected to net2 with an IP of 10.1.2.1).

These routers can be used and configured to control the flow of packets between servers in the network, simulating latency and packet loss, as well as firewalls blocking ports.

### Cassandra Nodes

Cassandra Nodes run the Cassandra DB instances. They are are configured with 1024MB of RAM and run a Cassandra database instance using the `GossipingPropertyFileSnitch` in addition to the `datastax-agent` for connecting with DataStax OpsCenter. Each node's Gossiping Property File is configured with a DataCenter name based on the 3rd octet of it's IP (so all nodes on net1 are in "DC1" and nodes on net2 are in "DC2", etc) and the Rack number is based on it's 4th octet (in this scenario, this means there is no rack overlap within a DataCenter).

### OpsCenter

The OpsCenter node runs the DataStax OpsCenter server. It is configured with 512MB of RAM and does not start up by default (more on that later). When started, Vagrant will automatically forward port 8888 on the host machine to port 8888 on the OpsCenter node. After navigating to the webpage, you will have to provide at least one node's IP (it is recommended to use one (or all) of the seed nodes which are started by default in the minimal config and their IPs are listed below).

Occasionally, it will be necessary to restart the DataStax agent on one of the nodes, which can cause OpsCenter to give errors about the node. If this happens, run the following command (replacing "cassandra-1-1" with the name of the node referenced by the error):

```bash
vagrant ssh cassandra-1-1 -- sudo /etc/init.d/datastax-agent restart
```

Initializing the Environment
----------------------------

```bash
vagrant up
```

This will initialize the following nodes:

* router-1-2 - Routes traffic between net1 and net2 (given static IPs of 10.1.1.2 and 10.1.2.1)
* router-2-3 - Routes traffic between net2 and net3 (given static IPs of 10.1.2.3 and 10.1.3.2)
* router-1-3 - Routes traffic between net1 and net3 (given static IPs of 10.1.1.3 and 10.1.3.1)
* cassandra-1-1 - First node on net1 (given a static IP of 10.1.1.50)
* cassandra-2-1 - First node on net2 (given a static IP of 10.1.2.50)
* cassandra-3-1 - First node on net3 (given a static IP of 10.1.3.50)

This represents the minimal configuration to test multi-DataCenter deployments.

Starting OpsCenter
------------------

```bash
vagrant up opscenter
```

This will initialize the following node:

* opscenter - Runs OpsCenter and forwards http://localhost:8888 to the OpsCenter webservice. Has static IPs 10.1.1.10 (net1), 10.1.2.10 (net2), and 10.1.3.10 (net3)

After the VM is booted and configured, go to http://localhost:8888 in a web browser on the host machine and select to connect to an existing cluster, and use one (or all) of the following nodes when asked:

* 10.1.1.50
* 10.1.2.50
* 10.1.3.50

After that, OpsCenter will connect to the cluster and provide real-time statistics and information on cluster and node health.

Starting additional Nodes
-------------------------

```bash
vagrant up cassandra-1-2 cassandra-2-2 cassandra-3-2 cassandra-1-3 cassandra-2-3 cassandra-3-3
```

The above command will launch all remaining nodes (for a total of 9: 3 in each virtual network) in the DHCP range. To launch less, remove a few nodes from the list. If OpsCenter is running, these nodes should automatically show up there; if OpsCenter gives errors, see above for information on restarting the `datastax-agent`.

Be warned that running all nodes (especially on an end-user system) can consume a lot of system resources, which may be shared with other applications. Currently, as of the time of this writing, running all nodes will consume about 11GB of RAM, which can be a lot on it's own, but is very taxing on a desktop with 16GB of RAM running multiple other applications. You've been warned!

Shutting Down the Environment
-----------------------------

To shut down all nodes:

```bash
vagrant destroy -f
```

Additionally, a specific node name can be added to the end of the above command to terminate a specific node.

This will uncleanly kill (and delete) all nodes. As these nodes are built from scratch with `vagrant up`, this is generally not a problem (and saves time as it doesn't wait for a shutdown).
