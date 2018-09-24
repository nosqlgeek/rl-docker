#!/bin/bash
id=`docker ps -a | grep 'sameersbn/bind' | cut -f1 -d' '`
docker kill $id
docker rm $id
