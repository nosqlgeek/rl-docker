# How to set up a custom DNS server for your Docker containers

Redis Enterprise is allowing you to connect via a fully qualified endpoint name. The demo database which is created by our `create_db.bash` script is for instance accessible via the public endpoint `redis-16379.cluster.ubuntu-docker.org:16379` and the private endpoint `redis-16379.internal.cluster.ubuntu-docker.org:16379`. The naming scheme is i.e. `redis-{port}.internal.{fqcn}`, whereby 'fqcn' is the fully qualified cluster name.

We need to have an extra DNS server in order to leverage this endpoint name. This article is describing how we can set it up in Docker by enabling other containers to use the fully qualified endpoint name of such a database.

## Installing and starting the DNS server

First of all, we need to start and install a DNS server. We are using 'Bind' in our example. A quick Google search pointed me to the following image, which comes with a nice graphical interface:

* sameersbn/bind

```
sudo ./start_dns.bash
```

I disabled the access from the outside world because this DNS will be used within your internal Docker network. It's also worth to mention that the DNS is stateful, which means that it will store the configuration files to `/srv/docker/bind` on your local host.

## Discovering the DNS server's IP address

In the next step we need to know on which internal IP our name server is listening.

```
./list_dns.bash
```

This gave me for instance `172.17.0.6`. If you don't have an 'sameersbn/bind' container running, then this will return 8.8.8.8 as the default name server.

## Pass the DNS configuration to the containers

The script `start.bash` was adapted by adding a `--dns` flag to it. This flag ensures that each container has the name server set inside the `/etc/resolv.conf`

## Configure the DNS

It's now possible to connect to the 'Webmin' UI by using 'https://<docker_host>:10000' (i.e. https://ubuntu-server:10000). The default user is 'root' and the default password is 'password'.

1. Delete all existing DNS zones
1. Add a new master zone, enter the domain name 'ubuntu-docker.org' and use the master server 'ns.ubuntu-docker.org'
1. Create a new address within your newly created master zone by using the name 'ns.ubuntu-docker.org' and the internal IP address of your DNS server's docker container
1. Apply the configuration by clicking on the 'Apply configuration button' in the upper right corner of the screen of the window
1. Navigate back to the 'Edit Master Zone' dialog and click the 'Edit Records File' button. Extend the records file to look like the following one:

```
$ttl 38400
ubuntu-docker.org.	IN	SOA	172.17.0.6. admin.ubuntu-docker.org. (
			1530094430
			10800
			3600
			604800
			38400 )
ns.ubuntu-docker.org.	IN	A	<dns server ip>
node1.cluster.ubuntu-docker.org.	IN	A	<node 1 ip>
node2.cluster.ubuntu-docker.org.	IN	A	<node 2 ip>
node3.cluster.ubuntu-docker.org.	IN	A	<node 3 ip>
ubuntu-docker.org.	IN	NS	ns.ubuntu-docker.org.
cluster.ubuntu-docker.org.	IN	NS	node1.cluster.ubuntu-docker.org.
cluster.ubuntu-docker.org.	IN	NS	node2.cluster.ubuntu-docker.org.
cluster.ubuntu-docker.org.	IN	NS	node3.cluster.ubuntu-docker.org.
```

The IP `<dns server ip>` should be in your case already the one of your DNS server's Docker container, but you need to extend the record set by adding the entries for your Redis Enterprise cluster. Each cluster node is running its own DNS server, which enables us to do a transparent failover in case that a node or database endpoint is failing.

> Don't forget to save AND apply the configuration to your Bind server!

Screenshots can be found [here](https://github.com/nosqlgeek/rl-docker/blob/master/img/README.md).


## Test it

From within a container in the same Docker network:

* Use 'dig' in order to try to resolve the name of one of your nodes:

```
apt-get install dnsutils
dig redis-16379.internal.cluster.ubuntu-docker.org
```

The answer should look like this:

```
;; QUESTION SECTION:
;redis-16379.internal.cluster.ubuntu-docker.org.	IN A

;; ANSWER SECTION:
redis-16379.internal.cluster.ubuntu-docker.org.	1 IN A 172.17.0.2

;; AUTHORITY SECTION:
cluster.ubuntu-docker.org. 38400 IN	NS	node3.cluster.ubuntu-docker.org.
cluster.ubuntu-docker.org. 38400 IN	NS	node1.cluster.ubuntu-docker.org.
cluster.ubuntu-docker.org. 38400 IN	NS	node2.cluster.ubuntu-docker.org.
```

* Connect to the database:

```
/opt/redislabs/bin/redis-cli -h redis-16379.internal.cluster.ubuntu-docker.org -p 16379
```

## Using multiple clusters

Here an example records file when multiple clusters are used.

> The IP of the DNS server changed in the meantime to 172.17.0.2 whereby the cluster nodes are starting with 172.17.0.3

```
$ttl 38400
ubuntu-docker.org.	IN	SOA	172.17.0.2. admin.ubuntu-docker.org. (
			1530094430
			10800
			3600
			604800
			38400 )
ns.ubuntu-docker.org.	IN	A	172.17.0.2
ubuntu-docker.org.	IN	NS	ns.ubuntu-docker.org.

node1.cluster.ubuntu-docker.org.	IN	A	172.17.0.3
node2.cluster.ubuntu-docker.org.	IN	A	172.17.0.4
node3.cluster.ubuntu-docker.org.	IN	A	172.17.0.5
cluster.ubuntu-docker.org.	IN	NS	node1.cluster.ubuntu-docker.org.
cluster.ubuntu-docker.org.	IN	NS	node2.cluster.ubuntu-docker.org.
cluster.ubuntu-docker.org.	IN	NS	node3.cluster.ubuntu-docker.org.

node1.cluster2.ubuntu-docker.org.	IN	A	172.17.0.6
node2.cluster2.ubuntu-docker.org.	IN	A	172.17.0.7
node3.cluster2.ubuntu-docker.org.	IN	A	172.17.0.8
cluster2.ubuntu-docker.org.	IN	NS	node1.cluster2.ubuntu-docker.org.
cluster2.ubuntu-docker.org.	IN	NS	node2.cluster2.ubuntu-docker.org.
cluster2.ubuntu-docker.org.	IN	NS	node3.cluster2.ubuntu-docker.org.



