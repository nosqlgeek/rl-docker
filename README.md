# Redis Enterprise Docker Examples

Some wrapper scripts in order to provision a Redis Enterprise cluster in Docker. The article is extending on https://hub.docker.com/r/redislabs/redis/ .

In addtion, there are are bunch of scripts which are helping with the setup of a DNS server. Redis Enterprise is supporting to connect via a fully qualified name to a database endpoint. This allows a transparent failover without the need to use additional discovery mechanisms (i.e. Sentinel or `CLUSTER SLOTS`). The DNS setup is currently not fully automated but needs some manual intervention. If you want to use name based access within your internal Docker network then:

1. Start the DNS server's container by using 'start_dns.bash'
1. Provision a cluster by using i.e. 'reprovision.bash'
1. Complete the DNS setup by configuring the DNS server as described in the [DNS setup guide](https://github.com/nosqlgeek/rl-docker/blob/master/DNSSETUP.md)


## How to use

Just navigate to the project folder

```
cd rl-docker
```

and then execute one of the scripts. The script 'reprovision.bash' is executing all steps in the following sequence:

1. Kill all existing Redis Enterprise containers
1. Start 3 new Redis Enterprise containers
1. Initialize the first container as the 'Master of the Cluster'
1. Let all the other nodes join the newly initialized cluster
1. Create a demo database

```
./reprovision.bash
```

## Listing the nodes

* This script is just listing all docker containers those are belonging to Redis Enterprise.

```
./list.bash
```

## Starting nodes

* This script is starting 3 docker containers by using the Redis Enterprise image.

```
./start.bash
```

## Initializing a cluster

* This script inits a cluster by taking the node with the name 'rs-1' as 'Master of the Cluster' node.

```
./init.bash
```

## Joining the cluster

* This script is letting all nodes (except the first one) join the previously initialized cluster.

```
./join.bash
```

## Creating a demo database

* This script is used in order to create a 1GB demo database which is listening on port 16379.

```
./create_db.bash
```

## Shell log-in

* This script is used in order to log-in to the first node of the cluster

```
./login.bash
```

## Reprovising a cluster

* This script performs all steps in order to provision a cluster (including a demo database).

```
./reprovision.bash
```

> Warning: This script will also call 'kill.bash', meaning that you will loose all previously provisioned Redis Enterprise containers

## Using 2 clusters

It's sometimes necessary to have 2 clusters for CRDB testing and demoing purposes.

The latest version is defining all the relevant settings in a file `settings.bash`. There are basically 2 templates:

* settings_cluster_1.bash
* settings_cluster_2.bash

The script 'switch_cluster.bash' is switching between these two templates by copying the one which is currently not in use to the file 'settings.bash'.

The other scripts are then working as usual, meaning that 'list.bash' will list all cluster nodes of the currently selected cluster.

Here an overview of the settings file:

```
## CLUSTER1
  
# Misc
export BIN_DIR=/opt/redislabs/bin
export PORT_OFFSET=0

# Cluster
export NAME_PREFIX=rs
export NUM_NODES=3
export FQN=cluster.ubuntu-docker.org
export USER=admin@ubuntu-docker.org
export PASSWD=redis

# Storage
export PATH_STORAGE=/var/opt/redislabs/persist
export PATH_TMP=/var/opt/redislabs/tmp

# Database
export DB_PORT=16379
```

The first line is indicating the cluster number. The script 'switch_cluster.bash' will take this line into account. The `PORT_OFFSET` is important because we can't use the same external ports for both clusters. The `NAME_PREFIX` is used in order to generate the docker container names. The containers of the first clusters are named 'rs-1' ... 'rs-3' whereby the containers of the second cluster are named 'crdb-1' ... 'crdb-3'. Each cluster has a `FQN` which is relevant regarding the name resolution. Our first cluster uses the FQN 'cluster.ubuntu-docker.org', whereby our second cluster is using 'cluster2.ubuntu-docker.org'. I also added the text file 'example_dns_records.txt' which contains some example DNS records.
