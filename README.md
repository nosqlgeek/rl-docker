# Redis Enterprise Docker Examples

This repo is providing some wrapper scripts in order to provision a Redis Enterprise cluster in Docker. The article is extending on https://hub.docker.com/r/redislabs/redis/ . The idea was to simplify the deployment of a Redis Labs cluster via vanialla Docker commands by using some KISS (keep it simple and stupid) bash scripts.

## Step 0 - Settings

All the scripts are working with relative paths to other scripts. So you need to change your working directory to the folder which is containing the scripts:

```
cd rl-docker
```

The script

* `settings.bash`

contains all the relevant environment variables. You should run the script at least once with the default settings in order to get an understanding what it does.

## Step 1 - Network setup

### Container network

The script

* `create_network.bash`

is used in order to prepare the bridged network in which your Redis Enteprise containers are running. The following settings are used:

* NET_NAME: The network name, which defaults to 'rs-net'
* NET_CIDR: The '/24' masked CIDR of your network, which defaults to '172.1.0.0/24'

### Internal DNS server

Redis Enterprise is supporting to connect via a fully qualified name to a database endpoint. This allows a transparent failover without the need to use additional discovery mechanisms (i.e. Sentinel or `CLUSTER SLOTS`).

The script

* `start_dns.bash`

is starting a bind DNS server. This container is using local storage in order to load the settings at startup. The bind DNS server is listening on the IP 'x.y.z.201', whereby 'x.y.z' is specified via the configured NET_CIDR. So the default IP is '172.1.0.201'. The DNS server is currently started but not readily configured. The file [Example Records File](https://github.com/nosqlgeek/rl-docker/blob/master/example_dns_records.txt) is showing the records file which can be used if you keep the default settings.

1. Ensure that the network is set up and that the DNS server is started
1. Complete the DNS setup by configuring the DNS server as described in the [DNS setup guide](https://github.com/nosqlgeek/rl-docker/blob/master/DNSSETUP.md). Some screen shots can be found here: [DNS setup guide](https://github.com/nosqlgeek/rl-docker/blob/master/img/README.md).

> Don't worry if you can't resolve to any name under the sub-domain 'cluster.ubuntu-docker.org' yet. You will need to have a cluster up and running in order get the name resolution of database endpoints working because:

* The 'top-level' DNS is telling the resolver on the client machine that one of the cluster nodes' DNS server is responsible for the sub-domain which matches the F(ully)Q(ualified)N(ame) of your cluster.
* The resolver will try to contact the DNS on a cluster node, but you might not yet have a cluster running at this point which means that it can't reach it. So we are expecting that the name resolution is working

### Reprovision the network

In order to ensure that the network is created and the DNS server is (re)started, the script

* `reprovision_network.bash`

can be used.

## Step 2 - Select your environment

It's sometimes necessary to have 2 clusters for CRDB testing and demoing purposes.

The default environment is the one of 'cluster 1'. There are basically 2 templates:

* `settings_cluster_1.bash`
* `settings_cluster_2.bash`

The script 'switch_cluster.bash' is switching between these two templates by copying the one which is currently not in use to the file `settings.bash`.

> Warning: Please keep in mind that `switch_cluster.bash` will override your previous changes in `settings.bash`.

Here some explainations about the template files: The first line is indicating the cluster number. You should not remove it as the script 'switch_cluster.bash' will take this line into account. The `PORT_OFFSET` is important because we can't use the same external ports for both clusters. It is also used as the offset for IP addresses within the same subnet. The `NAME_PREFIX` is used in order to generate the docker container names. By default, the containers of the first clusters are named 'rs-1' ... 'rs-3' whereby the containers of the second cluster are named 'crdb-1' ... 'crdb-3'. Each cluster has a `FQN` which is relevant regarding the name resolution. Our first cluster uses the FQN 'cluster.ubuntu-docker.org', whereby our second cluster is using 'cluster2.ubuntu-docker.org'. The example records file contains the records for both clusters.

## Step 3 - Reprovision a cluster

The script

* `reprovision.bash`

is calling a bunch of other scripts. The following steps are performed:

1. Killing all existing Redis Enterprise containers of the current environment
1. Starting NUM_NODES new Redis Enterprise containers
1. Initializing the first container as the 'Master of the Cluster'
1. Letting all the other nodes join the newly initialized cluster
1. Creating a demo database

> Warning: This script will also call 'kill.bash', meaning that you will loose all previously provisioned Redis Enterprise containers


## Commands

### List nodes

This script is just listing all docker containers those are belonging to Redis Enterprise.

```
./list.bash
```

## Start nodes

This script is starting 3 docker containers by using the Redis Enterprise image.

```
./start.bash
```

## Init a cluster

This script inits a cluster by taking the node with the name 'rs-1' as 'Master of the Cluster' node.

```
./init.bash
```

## Join a cluster

This script is letting all nodes (except the first one) join the previously initialized cluster.

```
./join.bash
```

## Create a demo database

This script is used in order to create a 1GB demo database which is listening on port 16379.

```
./create_db.bash
```

## Shell log-in

This script is used in order to log-in to the first node of the cluster

```
./login.bash
``
