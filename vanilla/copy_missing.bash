#!/bin/bash
CURR_WD=$PWD
PRIV_D=`echo $CURR_WD | sed 's/rl-docker/rl-docker-priv/g'`
echo priv_d = $PRIV_D
cp $PRIV_D/redislabs-5.2.2-22-xenial-amd64.tar .
