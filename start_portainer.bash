#!/bin/bash
source ./settings.bash

## Calculate the IP
net_ip_pre=`echo $NET_CIDR | cut -f 1 -d'/' | cut -f 1-3 -d'.'`
net_ip=${net_ip_pre}.212
echo ip = $net_ip

docker run --network $NET_NAME --ip $net_ip -d -p 9000:9000 portainer/portainer
