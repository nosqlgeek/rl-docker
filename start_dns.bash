#!/bin/bash
mkdir /srv/docker
mkdir /srv/docker/bind
chgrp docker /srv/docker/bind

docker run --name bind -d --restart=always \
  --publish 10000:10000/tcp \
  --volume /srv/docker/bind:/data \
  sameersbn/bind:9.10.3-20180127

#  --publish 53:53/tcp --publish 53:53/udp \
