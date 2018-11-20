#!/bin/bash
source ../settings.bash

## Calculate the IP
net_ip_pre=`echo $NET_CIDR | cut -f 1 -d'/' | cut -f 1-3 -d'.'`
net_ip=${net_ip_pre}.191
echo ip = $net_ip

docker run -it --network $NET_NAME --ip $net_ip --dns=172.1.0.201 -d --cap-add sys_resource --name van-1 -p 8443:8443 -p 9443:9443 -p 16379:16379 ubuntu-server
