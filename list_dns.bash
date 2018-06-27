#!/bin/bash
id=`docker ps -a | grep 'sameersbn/bind' | cut -f1 -d' '` 
ip=`docker inspect -f '{{ .NetworkSettings.IPAddress }}' $id`
echo $ip
