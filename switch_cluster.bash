#!/bin/bash
export CLUSTER1=./settings_cluster_1.bash
export CLUSTER2=./settings_cluster_2.bash
export SETTINGS=./settings.bash

curr=`grep CLUSTER1 settings.bash`

if [ "$curr" == "## CLUSTER1" ]
then
   echo Switching to cluster 2 ...
   cp $CLUSTER2 $SETTINGS
else
   echo Switching to cluster 1 ...
   cp $CLUSTER1 $SETTINGS
fi


