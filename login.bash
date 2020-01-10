#!/bin/bash
source ./settings.bash
export NODE1_ID=$NAME_PREFIX-1

master=`./list.bash | grep $NODE1_ID | cut -f1 -d' '`
echo master = $master

docker exec -u 0 -it $master bash
