#!/bin/bash
source ./settings.bash
export NODE1_ID=${NAME_PREFIX}-1

master=`./list.bash | grep $NODE1_ID | cut -f1 -d' '`
echo master = $master

docker cp ./create_db.json $master:/tmp/create_db.json 
docker exec $master bash -c "curl -k -u $USER:$PASSWD -H 'Content-type: application/json' -d @/tmp/create_db.json -X POST http://localhost:8080/v1/bdbs"
