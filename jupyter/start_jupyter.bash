#!/bin/bash
source ../settings.bash

export DEFAULT_IMG=jupyter-base-redis
export DEMO_IMG=$1

if [ "${DEMO_IMG}x" == "x" ]
then
   DEMO_IMG=$DEFAULT_IMG
fi

echo img = $DEMO_IMG

## Calculate the IP
net_ip_pre=`echo $NET_CIDR | cut -f 1 -d'/' | cut -f 1-3 -d'.'`
net_ip=${net_ip_pre}.221
echo ip = $net_ip

## Run Container
docker run --network $NET_NAME --ip $net_ip -d -p 8080:8888 -u root $DEMO_IMG

## Fix DNS
./fix_dns.bash

## Get own id
jup_id=`docker ps | grep jupyter | cut -f1 -d' '`

## Show password
docker exec $jup_id bash -c "jupyter notebook list"
