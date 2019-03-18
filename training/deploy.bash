#!/bin/bash
export CURR_WD=$PWD

source ./settings.bash

## Caused issues with SCP even if host key verification was disabled
DATE=`date +%s`
cp $HOME/.ssh/known_hosts $HOME/.ssh/known_hosts.bkp.$DATE
rm $HOME/.ssh/known_hosts

## Ensure that everything is there
cd ../vanilla
./copy_missing.bash
cd $CURR_WD

## Package
echo Packaging ...
cd ../..
tar -cvf rl-docker.tar rl-docker
mv rl-docker.tar $CURR_WD
cd $CURR_WD

## Deploy
CLEAN=0
DEPLOY=1

while read m; do
  echo "$m"
  if [ "$CLEAN" == "1" ]
  then
     echo Copying clean script ...
     scp -i training clean.bash ubuntu@${m}:/home/ubuntu/
     ssh -n -i training ubuntu@${m} 'sudo /home/ubuntu/clean.bash'
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
