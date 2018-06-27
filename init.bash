#!/bin/bash
export NODE1_ID=rs-1
export BIN_DIR=/opt/redislabs/bin
export PATH_STORAGE=/var/opt/redislabs/persist
export PATH_TMP=/var/opt/redislabs/tmp
export FQN=cluster.ubuntu-docker.org
export USER=admin@ubuntu-docker.org
export PASSWD=redis

master=`./list.bash | grep $NODE1_ID | cut -f1 -d' '`
echo master = $master
int_ip=`docker inspect -f '{{ .NetworkSettings.IPAddress }}' $master`

echo Initializing ...
echo ip = $int_ip

docker exec $master bash -c "$BIN_DIR/rladmin cluster create persistent_path $PATH_STORAGE ephemeral_path $PATH_TMP addr $int_ip external_addr $int_ip name $FQN username $USER password $PASSWD register_dns_suffix"
