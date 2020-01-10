#!/bin/bash
source ./settings.bash

dns=`./list_dns.bash`
echo dns = $dns


./list.bash | cut -f1 -d' ' | while read i
do
  docker exec -u 0 $i bash -c "echo nameserver $dns > /etc/resolv.conf"
  docker exec -u 0 $i bash -c "echo search $FQN >> /etc/resolv.conf"  
  docker exec -u 0 $i bash -c "sed -i 's/local-port=5300/local-port=53/g' /opt/redislabs/config/pdns.conf"
  docker exec -u 0 $i bash -c "/opt/redislabs/bin/supervisorctl restart pdns_server"
done
