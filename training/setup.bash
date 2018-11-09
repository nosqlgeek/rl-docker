#!/bin/bash
sudo apt-get install docker.io
sudo apt-get install git
cd /home/ubuntu
tar -xvf rl-docker.tar
cd /home/ubuntu/rl-docker
sudo ./create_network.bash
sudo ./start_dns.bash
sudo ./reprovision.bash
cd /home/ubuntu/rl-docker/vanilla
docker build -t ubuntu-server .
