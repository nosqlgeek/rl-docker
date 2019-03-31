#!/bin/bash
source ../settings.bash

dns=`../list_dns.bash`
echo dns = $dns


docker ps | grep jupyter | cut -f1 -d' ' | while read i
do
  docker exec $i bash -c "echo nameserver $dns > /etc/resolv.conf"
  docker exec $i bash -c "echo search $FQN >> /etc/resolv.conf"  
done
