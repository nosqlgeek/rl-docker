## CLUSTER1

# Container
export IMG_VERSION=5.2.2-24

# Misc
export BIN_DIR=/opt/redislabs/bin
export PORT_OFFSET=0

# Cluster
export NAME_PREFIX=rs
export NUM_NODES=3
export FQN=cluster.ubuntu-docker.org
export USER=admin@ubuntu-docker.org
export PASSWD=redis

# Network
export NET_NAME=rs-net
export NET_CIDR=172.1.0.0/24

# Storage
export PATH_STORAGE=/var/opt/redislabs/persist
export PATH_TMP=/var/opt/redislabs/tmp

# Database
export DB_PORT=16379
