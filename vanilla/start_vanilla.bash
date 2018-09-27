#!/bin/bash
docker run -it --network rs-net --ip 172.1.0.2 --dns=172.1.0.201 -d --cap-add sys_resource --name van-1 -p 38443:8443 -p 39443:9443 -p 16679:16379 ubuntu-server
