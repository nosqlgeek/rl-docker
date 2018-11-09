# Host prep

## Step 1 - Prepare an Ubuntu 16.04 instance

Install Ubuntu 16.04 on AWS, GCP by using the 'training' SSH key pair.


## Step 2 - Install Docker on Ubuntu 16.04

```
sudo apt-get install docker.io
```

## Step 3 - Install Git

```
sudo apt-get install git
```

## Step 4 - Checkpout this repo

```
git clone https://github.com/nosqlgeek/rl-docker
```

## Step 5 - Provision the network

```
cd rl-docker
sudo ./create_network.bash
```

## Step 6 - Start the DNS server

```
sudo ./start_dns.bash
```

## Step 7 - Reprovision the cluster

```
sudo ./reprovision.bash
```

## Step 8 - Admin UI

```
https://<ip>:18443
```

* user: admin@ubuntu-docker.org
* password: redis

## Step 9 - DNS Admin

```
https://<ip>:10000
```

* user: root
* password: password

## Step 10 - Login

```
sudo ./login.bash
```
