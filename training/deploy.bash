#!/bin/bash
export CURR_WD=$PWD

echo Packaging ...
cd ../..
tar -cvf rl-docker.tar rl-docker
mv rl-docker.tar $CURR_WD
cd $CURR_WD

while read m; do
  echo "$m"
  echo Copying ...
  scp -i training rl-docker.tar ubuntu@${m}:/home/ubuntu/
done < machines.txt
