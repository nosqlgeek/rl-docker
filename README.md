# Redis Enterprise Docker Examples

Some wrapper scripts in order to provision a Redis Enterprise cluster in Docker. The article is extending on https://hub.docker.com/r/redislabs/redis/ .

In addtion, there are are bunch of scripts which are helping with the setup of a DNS server. Redis Enterprise is supporting to connect via a fully qualified name to a database endpoint. This allows a transparent failover without the need to use additional discovery mechanisms (i.e. Sentinel or `CLUSTER SLOTS`). If you want to use name based access within your internal Docker network then:

1. Follow the instructions in the [DNS setup guide](https://github.com/nosqlgeek/rl-docker/blob/master/DNSSETUP.md)
1. Provision a cluster by using i.e. 'reprovision.bash'


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

## Reprovising a cluster

* This script performs all steps in order to provision a cluster (including a demo database).

```
./reprovision.bash
```

> Warning: This script will also call 'kill.bash', meaning that you will loose all previously provisioned Redis Enterprise containers
