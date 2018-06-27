#!/bin/bash
export DB_PORT=16379

for i in `seq 1 3`
do

  dns=`./list_dns.bash`
  echo dns = $dns

  echo "Starting container $i"
  docker run --dns=$dns -d --cap-add sys_resource --name rs-$i -p ${i}8443:8443 -p ${i}9443:9443 -p $((16379 + $i)):$DB_PORT redislabs/redis
done

