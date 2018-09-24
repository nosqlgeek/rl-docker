#!/bin/bash
function wait() {
   echo Please wait ...
   sleep $1
}

echo "### kill ###"
./kill.bash
wait 5

echo "### start ###"
./start.bash
wait 60

echo "### init ###"
./init.bash
wait 30

echo "### join ###"
./join.bash
wait 5

echo "### create_db ###"
./create_db.bash



