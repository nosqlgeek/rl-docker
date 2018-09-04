#!/bin/bash
source ./settings.bash
docker ps -a | grep redislabs | grep $NAME_PREFIX
