#!/bin/bash
sudo apt-get update
sudo apt-get install -y docker.io
sudo apt-get install -y git
cd /home/ubuntu
tar -xf rl-docker.tar
cd /home/ubuntu/rl-docker
sudo ./create_network.bash
sudo ./start_dns.bash
sudo ./reprovision.bash
cd /home/ubuntu/rl-docker/vanilla
sudo docker build -t ubuntu-server .
