#!/bin/bash
source ./settings.bash

echo "cidr = $NET_CIDR"
echo "net = $NET_NAME"

docker network create --driver=bridge --subnet=${NET_CIDR} ${NET_NAME}
docker network ls | grep ${NET_NAME}

