## Performing an installation from scratch by using a vanilla Ubuntu Server

* Download the Redis Enterprise Software installation package and place it in this folder

> The Dockerfile is currently referencing a file which is named redislabs-5.2.0.tar


* Build the container image

```
docker build -t ubuntu-server .
```

* Make sure that the network is set up

```
cd ..
./provision_network.bash
cd vanilla
```

* Start the container

```
./start_vanilla.bash
```

* Install Redis Enterprise

```
cd /opt
./install.sh -c install.conf
```

* Start Redis Enterprise

```
cd /opt
./start.sh
```
