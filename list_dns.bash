#!/bin/bash
# Try to find our local DNS, if it can't be found then return Google's name server

id=`docker ps -a | grep 'sameersbn/bind' | cut -f1 -d' '` 

if [ "${id}x" == "x" ]
then
   echo 8.8.8.8
else
   ip=`docker inspect -f '{{ .NetworkSettings.IPAddress }}' $id`
   echo $ip
fi
