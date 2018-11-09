#!/bin/bash
docker run -it --network rs-net --ip 172.1.0.191 --dns=172.1.0.201 -d --cap-add sys_resource --name van-1 -p 8443:8443 -p 9443:9443 -p 16379:16379 ubuntu-server
