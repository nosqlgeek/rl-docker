#!/bin/bash
export CURR_WD=$PWD

echo Packaging ...
cd ../..
tar -cvf rl-docker.tar rl-docker
mv rl-docker.tar $CURR_WD
cd $CURR_WD

CLEAN=1
DEPLOY=0

while read m; do
  echo "$m"
  if [ "$CLEAN" == "1" ]
  then
     echo Copying clean script ...
     scp -i training clean.bash ubuntu@${m}:/home/ubuntu/
     ssh -n -i training ubuntu@${m} /home/ubuntu/clean.bash
  fi

  if [ "$DEPLOY" == "1" ]
  then
    echo Copying rl-docker ...
    scp -i training rl-docker.tar ubuntu@${m}:/home/ubuntu/
    echo Copying setup script ...
    scp -i training setup.bash ubuntu@${m}:/home/ubuntu/
    echo Executing setup script ...
    ssh -n -i training ubuntu@${m} /home/ubuntu/setup.bash
  fi
done < machines.txt

rm rl-docker.tar
