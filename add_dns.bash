#!/bin/bash
export DB_PORT=16379
export FQN=cluster.ubuntu-docker.org

dns=`./list_dns.bash`
echo dns = $dns


./list.bash | cut -f1 -d' ' | while read i
do
  docker exec $i bash -c "echo nameserver $dns > /etc/resolv.conf"
  docker exec $i bash -c "echo search $FQN >> /etc/resolv.conf"  
done
