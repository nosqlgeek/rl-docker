#!/bin/bash
source ./settings.bash

for i in `seq 1 $NUM_NODES`
do

  dns=`./list_dns.bash`
  echo dns = $dns
 
  admin_port=$((${i}8443+$PORT_OFFSET))
  echo admin_port = $admin_port
  
  sadmin_port=$((${i}9443+$PORT_OFFSET))
  echo sadmin_port = $sadmin_port

  db_port=$(($DB_PORT + $i + $PORT_OFFSET))
  echo db_port = $db_port

  net_ip_pre=`echo $NET_CIDR | cut -f 1 -d'/' | cut -f 1-3 -d'.'`
  net_ip_suf=$(($i + $PORT_OFFSET + 1))
  net_ip=${net_ip_pre}.${net_ip_suf}
  echo ip = $net_ip

  echo "Starting container $i"
  docker run --network $NET_NAME --ip $net_ip --dns=$dns -d --cap-add sys_resource --name ${NAME_PREFIX}-$i -p $admin_port:8443 -p $sadmin_port:9443 -p $db_port:$DB_PORT redislabs/redis
done

