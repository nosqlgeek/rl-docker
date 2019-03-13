#!/bin/bash
export NAME_PREFIX=van
docker ps -a | grep $NAME_PREFIX
