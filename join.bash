#!/bin/bash
export NODE1_ID="rs-1"
export BIN_DIR=/opt/redislabs/bin
export PATH_STORAGE=/var/opt/redislabs/persist
export PATH_TMP=/var/opt/redislabs/tmp
export USER=admin@ubuntu-docker.org
export PASSWD=redis

master=`./list.bash | grep $NODE1_ID | cut -f1 -d' '`
master_ip=`docker inspect -f '{{ .NetworkSettings.IPAddress }}' $master`
echo master = $master
echo master_ip = $master_ip

./list.bash | grep -v $NODE1_ID | cut -f1 -d' ' | while read i
do
  echo Joining ...
  ip_int=`docker inspect -f '{{ .NetworkSettings.IPAddress }}' $i`
  echo ip = $ip_int

  docker exec $i bash -c  "$BIN_DIR/rladmin cluster join persistent_path $PATH_STORAGE ephemeral_path $PATH_TMP addr $ip_int external_addr $ip_int username $USER password $PASSWD nodes $master_ip"
done
