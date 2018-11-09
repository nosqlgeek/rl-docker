#!/bin/bash
export CURR_WD=$PWD

echo Packaging ...
cd ../..
tar -cvf rl-docker.tar rl-docker
mv rl-docker.tar $CURR_WD
cd $CURR_WD

while read m; do
  echo "$m"
  echo Copying rl-docker ...
  scp -i training rl-docker.tar ubuntu@${m}:/home/ubuntu/
  echo Copying setup script ...
  scp -i training setup.bash ubuntu@${m}:/home/ubuntu/
  echo Executing setup script ...
  ssh -n -i training ubuntu@${m} /home/ubuntu/setup.bash
done < machines.txt
