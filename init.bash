#!/bin/bash
source ./settings.bash

export NODE1_ID=${NAME_PREFIX}-1
export RACK_ZONE=rz-1

master=`./list.bash | grep $NODE1_ID | cut -f1 -d' '`
echo master = $master
int_ip=`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $master`

echo Initializing ...
echo ip = $int_ip

docker exec $master bash -c "$BIN_DIR/rladmin cluster create rack_aware rack_id $RACK_ZONE persistent_path $PATH_STORAGE ephemeral_path $PATH_TMP addr $int_ip external_addr 127.0.0.1 name $FQN username $USER password $PASSWD register_dns_suffix"
