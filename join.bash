#!/bin/bash
source ./settings.bash
export NODE1_ID="${NAME_PREFIX}-1"

master=`./list.bash | grep $NODE1_ID | cut -f1 -d' '`
master_ip=`docker inspect -f '{{ .NetworkSettings.IPAddress }}' $master`
echo master = $master
echo master_ip = $master_ip

count=1

./list.bash | grep -v $NODE1_ID | cut -f1 -d' ' | while read i
do
  let "count++"
  rack_zone="rz-$count"
  echo rz = $rack_zone

  echo "Node $count joining ..."
  ip_int=`docker inspect -f '{{ .NetworkSettings.IPAddress }}' $i`
  echo ip = $ip_int

  docker exec $i bash -c  "$BIN_DIR/rladmin cluster join rack_id $rack_zone persistent_path $PATH_STORAGE ephemeral_path $PATH_TMP addr $ip_int external_addr $ip_int username $USER password $PASSWD nodes $master_ip"
done
