#!/bin/bash
./list.bash | cut -f1 -d' ' | while read i
do
  echo Killing ...
  docker kill $i

  echo Removing ...
  docker rm $i
done
