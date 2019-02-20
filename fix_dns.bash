#!/bin/bash
source ./settings.bash

dns=`./list_dns.bash`
echo dns = $dns


./list.bash | cut -f1 -d' ' | while read i
do
  docker exec $i bash -c "sudo echo nameserver $dns > /etc/resolv.conf"
  docker exec $i bash -c "sudo echo search $FQN >> /etc/resolv.conf"  
done
