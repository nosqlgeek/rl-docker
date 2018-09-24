#!/bin/bash
source ./settings.bash

## Prepare directories
mkdir /srv/docker
mkdir /srv/docker/bind
chgrp docker /srv/docker/bind

## Calculate the IP
net_ip_pre=`echo $NET_CIDR | cut -f 1 -d'/' | cut -f 1-3 -d'.'`
net_ip=${net_ip_pre}.201
echo ip = $net_ip

## Run
docker run --name bind -d --restart=always \
  --network $NET_NAME --ip $net_ip \
  --publish 10000:10000/tcp \
  --volume /srv/docker/bind:/data \
  sameersbn/bind:9.10.3-20180127
